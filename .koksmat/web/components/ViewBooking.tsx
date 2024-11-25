import React from 'react';
import moment from 'moment-timezone';
import { Booking } from '../types/room-display';

interface ViewBookingProps {
  booking: Booking;
  timezone: string;
  onDelete?: () => void;
  canAdd15min?: boolean;
  onAdd15min?: () => void;
  roomEmail?: string;
}

export const ViewBooking: React.FC<ViewBookingProps> = ({
  booking,
  timezone,
  onDelete,
  canAdd15min,
  onAdd15min,
  roomEmail,
}) => {
  const startTime = moment.tz(booking.start.dateTime, booking.start.timeZone).tz(timezone);
  const endTime = moment.tz(booking.end.dateTime, booking.end.timeZone).tz(timezone);

  return (
    <div className="view-booking">
      <h3>{booking.subject}</h3>
      <p>
        {startTime.format('HH:mm')} - {endTime.format('HH:mm')}
      </p>
      <p>Organizer: {booking.organizer.emailAddress.name}</p>
      {onDelete && <button onClick={onDelete}>Delete</button>}
      {canAdd15min && onAdd15min && <button onClick={onAdd15min}>Add 15 minutes</button>}
    </div>
  );
};

