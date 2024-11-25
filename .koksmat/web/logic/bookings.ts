import moment from 'moment-timezone';
import _ from 'lodash';
import { Booking, BookingStatus } from '../types/room-display';

function todayHourMinute(h: number, m: number): moment.Moment {
  return moment().set({ hour: h, minute: m });
}

function createBooking(fromH: number, fromM: number, toH: number, toM: number, organizer: string): Booking {
  return {
    id: _.uniqueId('booking_'),
    start: {
      dateTime: todayHourMinute(fromH, fromM).toISOString(),
      timeZone: moment.tz.guess(),
    },
    end: {
      dateTime: todayHourMinute(toH, toM).toISOString(),
      timeZone: moment.tz.guess(),
    },
    subject: 'Mock Booking',
    organizer: {
      emailAddress: {
        name: organizer,
        address: `${organizer.toLowerCase().replace(' ', '.')}@example.com`,
      },
    },
  };
}

export function mockBookings(): Booking[] {
  return [
    createBooking(9, 0, 10, 0, 'John Doe'),
    createBooking(11, 30, 12, 30, 'Jane Smith'),
    createBooking(14, 0, 15, 30, 'Alice Johnson'),
  ];
}

function time(exchangeTime: { dateTime: string; timeZone: string }): moment.Moment {
  return moment.tz(exchangeTime.dateTime, exchangeTime.timeZone);
}

export function getCurrentBookingStatus(bookings: Booking[], now: moment.Moment): BookingStatus {
  let isAvailable = true;
  let availableFrom = moment(now);
  let availableTo = moment(now).endOf('day');
  let currentBooking: Booking | null = null;
  let nextBooking: Booking | null = null;

  const sortedBookings = _.sortBy(bookings, (o) => o.start.dateTime);

  for (const booking of sortedBookings) {
    const bookedFrom = time(booking.start);
    const bookedTo = time(booking.end);

    if (!nextBooking && bookedFrom.isAfter(now)) {
      nextBooking = booking;
      availableTo = time(booking.start);
    }

    if (now.isBetween(bookedFrom, bookedTo)) {
      isAvailable = false;
      currentBooking = booking;
      availableFrom = time(booking.end);
      break;
    }
  }

  const availableText = isAvailable
    ? `until ${availableTo.format('HH:mm')}`
    : `from ${availableFrom.format('HH:mm')}`;

  return {
    isAvailable,
    availableFrom,
    availableTo,
    currentBooking,
    nextBooking,
    availableText,
  };
}

interface TimeSlot {
  hour: number;
  min: number;
  status: 'busy' | 'free';
}

export function slots24hour(bookings: Booking[]): TimeSlot[] {
  const status = (hour: number, minute: number): 'busy' | 'free' => {
    const slotTime = moment().startOf('day').add(hour, 'hours').add(minute, 'minutes');
    return bookings.some((booking) => {
      const bookedFrom = time(booking.start);
      const bookedTo = time(booking.end);
      return slotTime.isBetween(bookedFrom, bookedTo, null, '[)');
    })
      ? 'busy'
      : 'free';
  };

  const slots: TimeSlot[] = [];
  for (let hour = 7; hour < 18; hour++) {
    for (let min = 0; min < 60; min += 15) {
      slots.push({ hour, min, status: status(hour, min) });
    }
  }

  return slots;
}

