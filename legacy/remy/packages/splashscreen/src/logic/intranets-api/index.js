import axios from "axios";
import _ from "lodash"
const host = true
  ? "https://nets-intranets-api.azurewebsites.net"
  : "http://localhost:8000";

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

export function getRoomBookingsForToday(email) {
  var config = {
    method: "get",
    url: host + "/v1.0/rooms/" + email + "/todays-bookings",
    headers: {},
  };

  return callAxios(config);
}

export function getRoom(email) {
  var config = {
    method: "get",
    url: host + "/v1.0/rooms/" + email,
    headers: {},
  };

  return callAxios(config);
}

export function getRooms() {
  var config = {
    method: "get",
    url: host + "/v1.0/rooms",
    headers: {},
  };
  return new Promise((resolve, reject) => {
    callAxios(config)
      .then((result) => {
        result.value = _.sortBy(result.value,["displayName"])
        resolve(result);
      })
      .catch((error) => reject(error));
  });
}


export function getSites() {
  var config = {
    method: "get",
    url: host + "/v1.0/sites",
    headers: {},
  };
  return new Promise((resolve, reject) => {
    callAxios(config)
      .then((result) => {
        result.value = _.sortBy(result.value,["displayName"])
        resolve(result);
      })
      .catch((error) => reject(error));
  });
}


export function getSiteRooms(email) {
  var config = {
    method: "get",
    url: host + "/v1.0/sites/"+email,
    headers: {},
  };
  return new Promise((resolve, reject) => {
    callAxios(config)
      .then((result) => {
        result.value = _.sortBy(result.value,["displayName"])
        resolve(result);
      })
      .catch((error) => reject(error));
  });
}


export function addBooking(email, startDateTime, endDateTime,timeZone) {
  var data = { startDateTime, endDateTime, timeZone: timeZone ? timeZone : "UTC" };

  var config = {
    method: "post",
    url: host + "/v1.0/bookings/" + email,
    headers: {
      "Content-Type": "application/json",
    },
    data: data,
  };

  return callAxios(config);
}

export function deleteBooking(email, id) {
  var config = {
    method: "delete",
    url: host + "/v1.0/bookings/" + email + "/" + id,
    headers: {
      "Content-Type": "application/json",
    },
  };

  return callAxios(config);
}
