import React, { useState, useEffect } from 'react';
import moment from 'moment-timezone';

interface ClockProps {
  timezone: string;
}

export const Clock: React.FC<ClockProps> = ({ timezone }) => {
  const [date, setDate] = useState(new Date());

  useEffect(() => {
    const timerID = setInterval(() => setDate(new Date()), 1000);
    return () => clearInterval(timerID);
  }, []);

  const now = moment(date).tz(timezone).format('HH:mm:ss');
  const day = moment(date).tz(timezone).format('dddd, D MMMM, YYYY');

  return (
    <div className="clock">
      <div className="clock-hm">{now}</div>
      <div className="clock-day">{day}</div>
    </div>
  );
};

