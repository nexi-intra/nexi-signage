import { Moment } from 'moment-timezone';

export interface RoomDisplayProps {
  email: string;
  timezone: string;
}

export interface Room {
  displayName: string;
  email: string;
}

export interface Booking {
  id: string;
  start: {
    dateTime: string;
    timeZone: string;
  };
  end: {
    dateTime: string;
    timeZone: string;
  };
  subject: string;
  organizer: {
    emailAddress: {
      name: string;
      address: string;
    };
  };
}

export interface BookingStatus {
  isAvailable: boolean;
  availableFrom: Moment;
  availableTo: Moment;
  currentBooking: Booking | null;
  nextBooking: Booking | null;
  availableText: string;
}

export interface Site {
  id: string;
  displayName: string;
  email: string;
}

