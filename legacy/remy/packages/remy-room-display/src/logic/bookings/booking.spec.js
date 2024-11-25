import {getCurrentBookingStatus } from "."

test('Booking status', () => {
    var [isAvailable, availableFrom,availableTo,currentBooking,nextBooking] = getCurrentBookingStatus()
  expect(isAvailable).toBeTruthy()
});
