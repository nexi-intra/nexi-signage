import React, { useState, useEffect } from "react";
import { Link } from "@reach/router";
import { getSiteRooms, getRoomBookingsForToday } from "../logic/intranets-api";

import "./Rooms.css";
import { slots24hour } from "../logic/bookings";

import Timeline from "react-calendar-timeline";
// make sure you include the timeline stylesheet or the timeline will not be styled
import "react-calendar-timeline/lib/Timeline.css";
import _ from "lodash";
import moment from "moment";
import TopNav from "../components/TopNav";

const Slots = (props) => {
  return (
    <div style={{ display: "flex" }}>
    <div>{props.bookings.length}</div>
      {props.slots.map((slot, key) => {
        return (
          <div key={key} class={"slot slot-" + slot.status}>
         
            {slot.bookings &&
              slot.bookings.map((booking, key) => {
                return <div key={key}>{booking.subject}</div>;
              })}
          </div>
        );
      })}
    </div>
  );
};

const MyTimeLine = (props) => {
  return (
    <Timeline
      groups={props.groups}
      items={props.items}
      defaultTimeStart={moment().add(-12, "hour")}
      defaultTimeEnd={moment().add(12, "hour")}
    />
  );
};
const Rooms = (props) => {
  const [rooms, setRooms] = useState([]);
  const [loaded, setLoaded] = useState(false);
  const [refresh, setRefresh] = useState(0);
  const [groups, setGroups] = useState([]);
  const [items, setItems] = useState([
    
  ]);
  useEffect(() => {
    async function run() {
      if (loaded) return;
      getSiteRooms(props.email).then(async (data) => {
        setLoaded(true);
        setRooms(data.value);


        var c = 0;
        var myGroups = []
        var myItems = []
        data.value.forEach(async (room) => {
          var bookings = await getRoomBookingsForToday(room.emailAddress);
          
          
            
            bookings.value.forEach((booking) => {
              myItems.push({
                id: myItems.length+1,
                group: room.emailAddress,
                title: "item 1",
                start_time: booking.start.dateTime,
                end_time: booking.end.dateTime,
              });
            });
          

          myGroups.push({ id: room.emailAddress, title: room.displayName });
      
          

          room.bookings = bookings.value;
          //debugger
          c++;
          setRefresh(c);
          setRooms(data.value);
        });
        setItems(myItems);
        setGroups(myGroups);
      });
    }
    run();
  }, [refresh]);

  const [error, setError] = useState("");

  return (
    <div>
    <TopNav />
      ROOMS
      <div>
        {rooms.map((room, key) => {
          return (
            <div style={{ display: "flex" }}>
              <div className="columnn-room">
                <a
                  target="_blank"
                  href={
                    "https://outlook.office.com/calendar/" + room.emailAddress
                  }
                >
                  {" "}
                  {room.displayName}{" "}
                </a>
              </div>
              {room.bookings && (
                <div>
                  
                  <Slots bookings={room.bookings} slots={slots24hour(room.bookings)} />
                </div>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
//     <MyTimeLine groups={_.cloneDeep(groups)} items={_.cloneDeep(items)} />

};

export default Rooms;
