import React from 'react';
import { Booking } from '../types/room-display';
import { ViewBooking } from './ViewBooking';

interface NextMeetingProps {
  nextBooking: Booking | null;
  timezone: string;
}

export const NextMeeting: React.FC<NextMeetingProps> = ({ nextBooking, timezone }) => {
  return (
    <div className="next">
      <div className="nextHeader">NEXT MEETING:</div>
      <div className="comingUp">
        {nextBooking ? (
          <ViewBooking booking={nextBooking} timezone={timezone} />
        ) : (
          <div>No upcoming meetings</div>
        )}
      </div>
    </div>
  );
};

