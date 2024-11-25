require("dotenv").config();
const axios = require("axios");
const formatjson = require("format-json");
const moment = require("moment");

function callAxios(config) {
  return new Promise((resolve, reject) => {
    axios(config)
      .then(function (response) {
        resolve(response.data);
      })
      .catch(function (error) {
        reject(error);
      });
  });
}

function getToken() {
  var qs = require("qs");
  var data = qs.stringify({
    grant_type: "client_credentials",
    client_id: process.env.INTRANETSAPIOFFICECLIENTID,
    client_secret: process.env.INTRANETSAPIOFFICECLIENTSECRET,
    scope: "https://graph.microsoft.com/.default",
  });

  var config = {
    method: "post",
    url:
      "https://login.microsoftonline.com/" +
      process.env.INTRANETSAPIOFFICECLIENTDOMAINID +
      "/oauth2/v2.0/token",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    data: data,
  };

  return callAxios(config);
}
function getPlaces(token) {
  var config = {
    method: "get",
    url: "https://graph.microsoft.com/v1.0/places/microsoft.graph.room",
    headers: {
      "Content-Type": "application/json",
      Authorization: "Bearer " + token,
    },
  };

  return callAxios(config);
}

function getRoomEvents(token, roomAddress) {
  var config = {
    method: "get",
    url:
      "https://graph.microsoft.com/v1.0/users/" +
      roomAddress +
      "/calendar/calendarView?startDateTime=2020-06-01T00:00:00&endDateTime=2020-07-02T23:59:59&$select=organizer,isAllDay,start,end,location",
    headers: {
      "Content-Type": "application/json",

      Authorization: "Bearer " + token,
    },
  };
  return callAxios(config);
}

function getRooms(token) {
  var config = {
    method: "get",
    url:
      "https://graph.microsoft.com/v1.0/places/microsoft.graph.room/?$top=100000",
    headers: {
      "Content-Type": "application/json",

      Authorization: "Bearer " + token,
    },
  };
  return callAxios(config);
}

function getSites(token) {
  var config = {
    method: "get",
    url:
      "https://graph.microsoft.com/v1.0/places/microsoft.graph.roomlist/?$top=100000",
    headers: {
      "Content-Type": "application/json",

      Authorization: "Bearer " + token,
    },
  };
  return callAxios(config);
}
function getSite(token, siteSMTP) {
  var config = {
    method: "get",
    url:
      "https://graph.microsoft.com/v1.0/places/" +
      siteSMTP +
      "/microsoft.graph.roomlist/rooms?$top=100000",
    headers: {
      "Content-Type": "application/json",

      Authorization: "Bearer " + token,
    },
  };
  return callAxios(config);
}

function getRoom(token, roomAddress) {
  var config = {
    method: "get",
    url:
      "https://graph.microsoft.com/v1.0/places/microsoft.graph.room/" +
      roomAddress,
    headers: {
      "Content-Type": "application/json",

      Authorization: "Bearer " + token,
    },
  };
  return callAxios(config);
}
function getTodaysBookings(token, roomAddress) {
  moment().subtract(1, "days").startOf("day").toString();

  var startOfToday = moment().startOf("day").toISOString();
  var endOfToday = moment().endOf("day").toISOString();
  var url =
    "https://graph.microsoft.com/v1.0/users/" +
    roomAddress +
    "/calendar/calendarView?startDateTime=" +
    startOfToday +
    "&endDateTime=" +
    endOfToday +
    "&$select=organizer,isAllDay,start,end,location";

  var config = {
    method: "get",
    url,
    headers: {
      "Content-Type": "application/json",
      Authorization: "Bearer " + token,
    },
  };
  return callAxios(config);
}

function book(token, roomAddress, startDateTime, endDateTime, timeZone) {
  moment().subtract(1, "days").startOf("day").toString();

  var data = {
    subject: "Booked from display",
    body: {
      contentType: "HTML",
      content:
        "Call link: https://aka.ms/mmkv1b Submit a question: https://aka.ms/ybuw2i",
    },
    start: { dateTime: startDateTime, timeZone },
    end: { dateTime: endDateTime, timeZone },
  };

  var config = {
    method: "post",
    url: "https://graph.microsoft.com/v1.0/users/" + roomAddress + "/events",
    headers: {
      "Content-Type": "application/json",
      Authorization: "Bearer " + token,
    },
    data: data,
  };

  return callAxios(config);
}
function deleteBooking(token, roomAddress, bookingId) {
  var config = {
    method: "delete",
    url:
      "https://graph.microsoft.com/v1.0/users/" +
      roomAddress +
      "/calendar/events/" +
      bookingId,
    headers: {
      "Content-Type": "application/json",
      Authorization: "Bearer " + token,
    },
  };

  return callAxios(config);
  allAxios(config);
}
function extendBooking(token, roomAddress, bookingId, endDateTime, timeZone) {
  var data = {
    end: { dateTime: endDateTime, timeZone },
  };

  var config = {
    method: "patch",
    url:
      "https://graph.microsoft.com/v1.0/users/" +
      roomAddress +
      "/calendar/events/" +
      bookingId,
    headers: {
      "Content-Type": "application/json",
      Authorization: "Bearer " + token,
    },
    data: data,
  };

  return callAxios(config);
  allAxios(config);
}
function setupSubscription(token, roomAddress) {
  var expirationDateTime = moment().add(1, "days").toISOString();

  var data = {
    changeType: "created,updated,deleted",
    notificationUrl: process.env.REMYNOTIFYURL,
    resource: "/users/" + roomAddress + "/events",
    expirationDateTime: expirationDateTime,
    clientState: "secretClientState",
  };

  var config = {
    method: "post",
    url: "https://graph.microsoft.com/v1.0/subscriptions",
    headers: {
      "Content-Type": "application/json",
      Authorization: "Bearer " + token,
    },
    data: data,
  };

  return callAxios(config);
}
async function testAll() {
  var data = await getToken();
  var rooms = await getRooms(data.access_token);

  rooms.value.forEach(async (room) => {
    var events = await setupSubscription(
      data.access_token,
      room.emailAddress // "room-dk-kb601-21e1@nets.eu"
    );
    console.log(formatjson.plain(events));
  });
}

async function testOne() {
  var data = await getToken();

  var events = await setupSubscription(
    data.access_token,
    "room-dk-kb601-21e1@nets.eu"
  );
  console.log(formatjson.plain(events));
}
module.exports = {
  book,
  deleteBooking,
  extendBooking,
  getPlaces,
  getToken,
  getRoomEvents,
  getTodaysBookings,
  getRoom,
  getRooms,
  getSites,
  getSite,
};

//test();
//testOne()
