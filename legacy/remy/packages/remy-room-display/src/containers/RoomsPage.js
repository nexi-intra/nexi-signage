import React, { useState, useEffect } from "react";
import { Link } from "@reach/router";
import { getRooms, getRoomBookingsForToday } from "../logic/intranets-api";

import "./Rooms.css";
import TopNav from "../components/TopNav";
const Rooms = (props) => {
  const [rooms, setRooms] = useState([]);
  const [isApiOK, setIsApiOK] = useState(true);
  const [apiErrorCode, setApiErrorCode] = useState("");

  useEffect(() => {
    async function run() {
      getRooms().then((rooms) => setRooms(rooms.value)).catch(error=>{
        setApiErrorCode(error.message)
        setIsApiOK(false)
      });
    }
    run();
  }, []);

  const [error, setError] = useState("");
  return (
    <div>
    <TopNav/>
      ROOMS
      {!isApiOK && <div style={{color:"red",fontSize:"24px",padding:"20px"}}>

        {apiErrorCode} - You might not be connected from a trusted network
        </div>}
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
