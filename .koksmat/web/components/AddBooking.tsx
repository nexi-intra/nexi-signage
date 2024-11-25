import React from 'react';

interface AddBookingProps {
  onAdd: () => void;
}

export const AddBooking: React.FC<AddBookingProps> = ({ onAdd }) => {
  return (
    <button onClick={onAdd} className="add-booking-button">
      Book Now
    </button>
  );
};

