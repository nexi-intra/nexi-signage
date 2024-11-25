import React, { useState, useEffect } from "react";
import {
  Free,
  Buzy,
  Next,
  ViewBooking,
  AddBooking,
} from "../components/RoomDisplay";
import {
  getRoom,
  getRoomBookingsForToday,
  addBooking,
  deleteBooking,
} from "../logic/intranets-api";

import { useTimer } from "react-timer-hook";
import { getCurrentBookingStatus } from "../logic/bookings";
import moment from "moment-timezone";

import "./RoomDisplayPage.css";
import TopNav from "../components/TopNav";
const Room = (props) => {
  
  const [room, setRoom] = useState({});

  useEffect(() => {
    async function run() {
      getRoomBookingsForToday(props.email).then((data) =>
        setRoomBookings(data.value)
      );
      getRoom(props.email).then((room) => {
        setRoom(room);
      });
    }
    run();
  }, [props.email]);

  const [error, setError] = useState("");
  const [roomBookings, setRoomBookings] = useState([]);
  var [
    isAvailable,
    availableFrom,
    availableTo,
    currentBooking,
    nextBooking,
    availableText,
  ] = getCurrentBookingStatus(roomBookings, moment());

  const CurrentStatus = () => {
    return (
      <div
        className={isAvailable ? "room-available" : "room-buzy"}
        style={{ fontSize: "100px", textAlign: "center" }}
      >
        {isAvailable && (
          <div>
            <div className="status-block">
              <div className="status-heading">Available</div>
              <div className="status-subheading">
                Available next {availableText}
              </div>
            </div>
            <AddBooking
              onAdd={async (startDateTime, endDateTime) => {
                startDateTime = moment().format("YYYY-MM-DDTHH:mm:00");

                endDateTime = moment()
                  .add(15, "m")
                  .format("YYYY-MM-DDTHH:mm:00");
                await addBooking(props.email, startDateTime, endDateTime);
                window.location.reload();
                //setRefresh(refresh + 1);
              }}
            ></AddBooking>
          </div>
        )}
        {!isAvailable && (
          <div>
            <ViewBooking
              onDelete={async (id) => {
                await deleteBooking(props.email, id);
                window.location.reload();
              }}
              {...currentBooking}
            />
          </div>
        )}
      </div>
    );
  };
  const DisplayHeader = () => {
    return <div className="displaytitle"> {room.displayName} </div>;
  };

  const ComingUp = () => {
    if (!nextBooking) return <div>No upcoming meetings</div>;
    return (
      <div>
        Next booking
        <ViewBooking {...nextBooking} />
      </div>
    );
  };

  const ListAllBookings = () => {
    return (
      <div>
        <div style={{ padding: "16px" }}></div>
        {roomBookings.map((booking) => {
          return (
            <ViewBooking
              onDelete={async (id) => {
                await deleteBooking(props.room.email, id);
                window.location.reload();
              }}
              {...booking}
            />
          );
        })}
      </div>
    );
  };

  const Clock = () => {
    var now = moment().format("HH:MM");
    var day = moment().format("dddd, MMMM D, YYYY");
    return (
      <div className="clock">
        <div className="clock-hm">{now}</div>

        <div className="clock-day">{day}</div>
      </div>
    );
  };
  /**
   * <span>{days}</span>:<span>{hours}</span>:<span>{minutes}</span>:<span>{seconds}</span>
   */
  return (
    <div>
    <TopNav />
      <DisplayHeader />

      <CurrentStatus />
      <div className="next">
        <div className="nextHeader">NEXT</div>
        <ComingUp />
      </div>

      <Clock />
    </div>
  );
};

export default Room;
