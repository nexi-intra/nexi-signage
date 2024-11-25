import React from 'react';
import moment from 'moment-timezone';
import { BookingStatus, Booking } from '../types/room-display';
import { AddBooking } from './AddBooking';
import { ViewBooking } from './ViewBooking';

interface CurrentStatusProps {
  bookingStatus: BookingStatus;
  onAddBooking: (startDateTime: moment.Moment, endDateTime: moment.Moment) => Promise<void>;
  onDeleteBooking: (id: string) => Promise<void>;
  onExtendBooking: (id: string) => Promise<void>;
  timezone: string;
  roomEmail: string;
}

export const CurrentStatus: React.FC<CurrentStatusProps> = ({
  bookingStatus,
  onAddBooking,
  onDeleteBooking,
  onExtendBooking,
  timezone,
  roomEmail,
}) => {
  const { isAvailable, currentBooking, nextBooking } = bookingStatus;

  const handleAddBooking = () => {
    const startDateTime = moment().tz(timezone);
    let endDateTime = moment().tz(timezone).add(15, 'm').endOf('hour').add(1, 's');

    if (nextBooking) {
      const nextStart = moment.tz(nextBooking.start.dateTime, nextBooking.start.timeZone);
      if (endDateTime.isAfter(nextStart)) {
        endDateTime = nextStart.tz(timezone);
      }
    }

    onAddBooking(startDateTime, endDateTime);
  };

  return (
    <div className={`room-status-block ${isAvailable ? 'room-available' : 'room-buzy'}`}>
      {isAvailable ? (
        <AddBooking onAdd={handleAddBooking} />
      ) : (
        currentBooking && (
          <ViewBooking
            booking={currentBooking}
            timezone={timezone}
            onDelete={() => onDeleteBooking(currentBooking.id)}
            canAdd15min={moment(currentBooking.end.dateTime).diff(moment(), 'minutes') > 14}
            onAdd15min={() => onExtendBooking(currentBooking.id)}
            roomEmail={roomEmail}
          />
        )
      )}
    </div>
  );
};

