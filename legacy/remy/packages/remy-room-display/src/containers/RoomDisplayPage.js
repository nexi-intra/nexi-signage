import React, { useState, useEffect } from "react";
import {
  Free,
  Buzy,
  Next,
  ViewBooking,
  AddBooking
} from "../components/RoomDisplay";
import {
  getRoom,
  getRoomBookingsForToday,
  addBooking,
  deleteBooking,
  extendBooking
} from "../logic/intranets-api";

import { useTimer } from "react-timer-hook";
import { getCurrentBookingStatus } from "../logic/bookings";
import moment from "moment-timezone";

import "./RoomDisplayPage.css";

import backgroupUpperRight from "../media/lowerleft.png";
import logo from "../media/logo.png";
const RoomDisplay = (props) => {
  const [room, setRoom] = useState({});
  const [isLoaded, setIsLoaded] = useState(false);
  const [isUpdating, setIsUpdating] = useState(false);
  
  const timeZone = unescape(props.timezone);
  useEffect(() => {
    async function run() {
      getRoomBookingsForToday(props.email).then((data) => {
        setRoomBookings(data.value);
        setIsLoaded(true);
      });
      getRoom(props.email).then((room) => {
        setRoom(room);
      });
    }
    run();
    var timerID = setInterval(() => run(), 10000);
    return function cleanup() {
      clearInterval(timerID);
    };
  }, [props.email]);

  const [error, setError] = useState("");
  const [roomBookings, setRoomBookings] = useState([]);
  const [freeMinutes,setFreeMinutes] = useState(0)
  var [
    isAvailable,
    availableFrom,
    availableTo,
    currentBooking,
    nextBooking,
    availableText,
  ] = getCurrentBookingStatus(roomBookings, moment());

  const CurrentStatus = () => {

    if (!isAvailable){
      setFreeMinutes(moment(availableTo).diff(currentBooking.end.dateTime+"Z",'minutes'))
    } 

    return (
      <div
        className={
          "room-status-block " + (isAvailable ? "room-available" : "room-buzy")
        }
        style={{ fontSize: "100px", textAlign: "center" }}
      >
        {isAvailable && (
          <div>
            <div className="status-block">
              <div className="status-subheading"></div>
            </div>

            <AddBooking
              onAdd={async (startDateTime, endDateTime) => {
                startDateTime = moment().tz(timeZone);

                endDateTime = moment()
                  .tz(timeZone)
                  .add(15, "m")
                  .endOf("hour")
                  .add(1, "s");
                if (nextBooking) {
                  
                  var nextStart = moment.tz(nextBooking.start.dateTime, nextBooking.start.timeZone);
                   if (endDateTime.isAfter(nextStart)) {
                    
                     endDateTime = nextStart.tz(timeZone);
                     var h = moment(endDateTime).hour()
                     
                   }
                }

                var formatStart = startDateTime.format("YYYY-MM-DDTHH:mm:00")
                var formatEnd = endDateTime.format("YYYY-MM-DDTHH:mm:00")
                setIsUpdating(true)
                await addBooking(
                  props.email,
                  formatStart,
                  formatEnd,
                  timeZone
                );
                window.location.reload();
                //setRefresh(refresh + 1);
              }}
            ></AddBooking>
          </div>
        )}
        {!isAvailable && (
          <div>
            <ViewBooking
              timezone={timeZone}
              onDelete={async (id) => {
                setIsUpdating(true)
                await deleteBooking(props.email, id);
                window.location.reload();
              }}
              canAdd15min = {freeMinutes > 14}
              onAdd15min={async (id) => {
                
                var newEndDataTime = moment(currentBooking.end.dateTime).add(15,"minutes").format("YYYY-MM-DDTHH:mm:00")
                setIsUpdating(true)
                await extendBooking(props.email, id,newEndDataTime,"UTC");
                window.location.reload();
              }}
              {...currentBooking}
              roomEmail={props.email}
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
        <ViewBooking timezone={timeZone} {...nextBooking} />
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
              timezone={timeZone}
              onDelete={async (id) => {
                setIsUpdating(true)
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
    var now = moment().tz(timeZone).format("HH:mm:ss");
    var day = moment().tz(timeZone).format("dddd, D MMMM, YYYY");
    const [date, setDate] = React.useState(new Date());

    //Replaces componentDidMount and componentWillUnmount
    React.useEffect(() => {
      var timerID = setInterval(() => tick(), 1000);
      return function cleanup() {
        clearInterval(timerID);
      };
    });

    function tick() {
      setDate(new Date());
    }

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
    <div className="room-display">
      <img className="imgUpperRight" src={backgroupUpperRight} />

      <Clock />

      {isLoaded && (
        <div>
          <DisplayHeader />
          {!isUpdating &&
          <CurrentStatus />}
          {isUpdating &&
            <div className="wait">
            Wait
            </div>}
            <div className="next">
            <div className="nextHeader">NEXT MEETING:</div>
            <div className="comingUp">
            <ComingUp />
            </div>
          </div>
        </div>
      )}
      <img className="imgLowerRight" src={logo} />
    </div>
  );
};

export default RoomDisplay;
