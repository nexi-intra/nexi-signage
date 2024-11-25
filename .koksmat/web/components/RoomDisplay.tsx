import React, { useState, useEffect } from 'react';
import moment from 'moment-timezone';
import { RoomDisplayProps, Room, Booking, BookingStatus } from '../types/room-display';
import { getRoom, getRoomBookingsForToday, addBooking, deleteBooking, extendBooking } from '../logic/intranets-api';
import { getCurrentBookingStatus } from '../logic/bookings';
import { Clock } from './Clock';
import { CurrentStatus } from './CurrentStatus';
import { NextMeeting } from './NextMeeting';

const RoomDisplay: React.FC<RoomDisplayProps> = ({ email, timezone }) => {
  const [room, setRoom] = useState<Room>({ displayName: '', email: '' });
  const [isLoaded, setIsLoaded] = useState(false);
  const [isUpdating, setIsUpdating] = useState(false);
  const [roomBookings, setRoomBookings] = useState<Booking[]>([]);
  const [bookingStatus, setBookingStatus] = useState<BookingStatus>({
    isAvailable: true,
    availableFrom: moment(),
    availableTo: moment(),
    currentBooking: null,
    nextBooking: null,
    availableText: '',
  });

  useEffect(() => {
    const fetchData = async () => {
      const bookings = await getRoomBookingsForToday(email);
      setRoomBookings(bookings.value);
      const roomData = await getRoom(email);
      setRoom(roomData);
      setIsLoaded(true);
    };

    fetchData();
    const intervalId = setInterval(fetchData, 10000);

    return () => clearInterval(intervalId);
  }, [email]);

  useEffect(() => {
    setBookingStatus(getCurrentBookingStatus(roomBookings, moment()));
  }, [roomBookings]);

  const handleAddBooking = async (startDateTime: moment.Moment, endDateTime: moment.Moment) => {
    setIsUpdating(true);
    await addBooking(
      email,
      startDateTime.format('YYYY-MM-DDTHH:mm:00'),
      endDateTime.format('YYYY-MM-DDTHH:mm:00'),
      timezone
    );
    window.location.reload();
  };

  const handleDeleteBooking = async (id: string) => {
    setIsUpdating(true);
    await deleteBooking(email, id);
    window.location.reload();
  };

  const handleExtendBooking = async (id: string) => {
    if (bookingStatus.currentBooking) {
      setIsUpdating(true);
      const newEndDateTime = moment(bookingStatus.currentBooking.end.dateTime)
        .add(15, 'minutes')
        .format('YYYY-MM-DDTHH:mm:00');
      await extendBooking(email, id, newEndDateTime, 'UTC');
      window.location.reload();
    }
  };

  return (
    <div className="room-display relative min-h-screen bg-[#E6F3FF]">
      <img
        className="absolute top-0 right-0 w-1/3 h-auto"
        src="/signage/upper-right.svg"
        alt=""
        role="presentation"
      />

      <Clock timezone={timezone} />

      {isLoaded && (
        <div className="relative z-10">
          <div className="displaytitle">{room.displayName}</div>
          {!isUpdating ? (
            <CurrentStatus
              bookingStatus={bookingStatus}
              onAddBooking={handleAddBooking}
              onDeleteBooking={handleDeleteBooking}
              onExtendBooking={handleExtendBooking}
              timezone={timezone}
              roomEmail={email}
            />
          ) : (
            <div className="wait">Wait</div>
          )}
          <NextMeeting nextBooking={bookingStatus.nextBooking} timezone={timezone} />
        </div>
      )}

      <img
        className="absolute bottom-4 right-4 w-24 h-auto"
        src={"/signage/logo.png"}
        alt="Nets"
      />

      <img
        className="absolute bottom-0 left-0 w-1/3 h-auto"
        src={"/signage/lowerleft.png"}
        alt=""
        role="presentation"
      />

      <div
        className="absolute inset-0 z-0 bg-contain bg-no-repeat bg-right-bottom pointer-events-none"
        style={{ backgroundImage: `url(${"/signage/background.png"})` }}
        role="presentation"
      />
    </div>
  );
};

export default RoomDisplay;

