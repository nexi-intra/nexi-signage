import React, { useState, useEffect } from "react";
import { Link } from "@reach/router";
import { getRooms, getRoomBookingsForToday } from "../logic/intranets-api";

import "./Rooms.css";
import TopNav from "../components/TopNav";
const Rooms = (props) => {
  const [rooms, setRooms] = useState([]);

  useEffect(() => {
    async function run() {
      getRooms().then((rooms) => setRooms(rooms.value));
    }
    run();
  }, []);

  const [error, setError] = useState("");
  return (
    <div>
    <TopNav/>
      ROOMS
      <div>
        {rooms.map((room, key) => {
          return (
            <div>
            {room.displayName} ({room.emailAddress})
              <Link to={"/room/" + room.emailAddress + "/display"}>
                display
              </Link>
              <a
              target="_blank"
                href={
                  "https://outlook.office.com/calendar/" + room.emailAddress + "/view/workweek"
                }
              >
                {" "}
                Outlook Calendar
              </a>
            </div>
          );
        })}
      </div>
    </div>
  );
};

export default Rooms;
