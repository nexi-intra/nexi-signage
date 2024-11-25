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

import backgroupUpperRight from "../media/lowerleft.png";
import logo from "../media/logo.png";
const SplashPage = (props) => {


  

  var url = "https://apps.powerapps.com/play/11895e09-d2f9-459b-ac3f-aa3b222d9ab1?tenantId=79dc228f-c8f2-4016-8bf0-b990b6c72e98" + (window.location.search ? "&"+window.location.search.substring(1) :"")  

  return (
    <div className="room-display">
      <img className="imgUpperRight" src={backgroupUpperRight} />


      
        <div>
          <div className="next">
            <div className="nextHeader">
            
            <a className="clickhere" href={url}>Click here if you are the Meeting Organizer</a>
            <div style={{padding:"20px"}}>
            "CAVA" is an internal tool use by Nets for handling meeting services.
            </div>
            
            
            </div>
      
          </div>
        </div>
      
      <img className="imgLowerRight" src={logo} />
    </div>
  );
};

export default SplashPage;
