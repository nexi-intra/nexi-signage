import React, { useState } from "react";
import "./display.css";
import moment from "moment";
import momenttz from "moment-timezone";
import TimePicker from "react-time-picker";

export const Buzy = (props) => {
  return (
    <div className="buzy-container">
      {props.title}
      <div className="buzy-container-status-red"></div>
    </div>
  );
};

export const Free = () => {
  return <div>Free</div>;
};

export const Next = () => {
  return <div>Next</div>;
};

export const AddBooking = (props) => {
  const [value, onChange] = useState("10:00");
  /**
     *  <TimePicker
        onChange={onChange}
        value={value}
      />
     */
  return (
    <div style={{ textAlign: "center" }}>
      <button
        onClick={() => {
          if (props.onAdd) {
            props.onAdd();
          }
        }}
      >
        Book now
      </button>
    </div>
  );
};

const organizer = (organizer,roomEmail) => {
  if (!organizer) return null;
  if (!organizer.emailAddress) return null;

  if (roomEmail && organizer.emailAddress.address===roomEmail) return "Spontaneous meeting"
  return (
    organizer.emailAddress.name //+ " (" + organizer.emailAddress.address + ")"
  );
};

export const ViewBooking = (props) => {
  const tz = props.timezone ? props.timezone : "Europe/Berlin";
  function hhmm(time) {
    var dateTime = moment.tz(time.dateTime, time.timeZone);
    //return moment.tz(dateTime,"Asia/Taipei").format("hh:mm")
    return moment(dateTime).tz(tz).format("HH:mm");
  }
var marginTop = props.onDelete || props.onChange ? "40px ": "0px"
  return (
    <div style={{ xpadding: "10px" }}>
      <div style={{ textAlign: "center" }}>
        {hhmm(props.start)} - {hhmm(props.end)} &nbsp;
        {organizer(props.organizer,props.roomEmail)}
      </div>
      <div style={{ textAlign: "center" ,marginTop:marginTop}}>
        {props.onDelete && (
          <button
            onClick={() => {
              if (props.onDelete) {
                props.onDelete(props.id);
              }
            }}
          >
            End now
          </button>


        )}
        { props.onAdd15min && (
          <button
            style={{ marginLeft: "10px",    backgroundColor: props.canAdd15min ? "#34a940" : "#cccccc", color: props.canAdd15min ? "#ffffff" : "#000000"
         }}
            onClick={() => {
              if (props.onAdd15min && props.canAdd15min) {
                props.onAdd15min(props.id);
              }
            }}
          >
           +15 min. 
          </button>
        )}
      </div>
    </div>
  );
};
