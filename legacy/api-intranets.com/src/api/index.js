var Boom = require("@hapi/boom");
var _ = require("lodash");
var AUTH = require("../logic/auth");
var fs = require("fs-extra");
var path = require("path");
var OFFICE365 = require("../logic/office365");
const { JSONCookie } = require("cookie-parser");
const Joi = require("@hapi/joi");

const authenticate = {
  handler: async (request) => {
    var payload = request.payload;
    var fromIpAddress = request.headers["cf-connecting-ip"];
    var fromCountryCode = request.headers["cf-ipcountry"];
    var result = await require("../logic/auth").getTokenForMSAL(payload.token);
    return result.hasError
      ? Boom.forbidden(result.error)
      : { token: result.token, fromIpAddress, fromCountryCode };
  },
  metadata: {
    description: "Secure Token Server",
    notes: "Authentication point",
    validate: {},
  },
};

const desktop = {
  handler: async (request) => {
    var payload = request.payload;
    var error = false;
    var result = await require("../logic/desktop")
      .action(request.auth.credentials.claims.upn, payload)
      .catch((e) => {
        error = e;
      });

    return error ? Boom.forbidden(error) : { result };
  },
  metadata: {
    description: "Desktop proxy",
    notes: "Transfers request to be execute on connected desktop",
    validate: {},
  },
};

const places = {
  handler: async (request) => {
    var auth = await OFFICE365.getToken();
    var places = await OFFICE365.getPlaces(
      auth.access_token
    ).catch((error) => {});
    return places;
  },
  metadata: {
    id: "places",
    description: "Return places",
    validate: {},
  },
};

const room = {
  handler: async (request) => {
    var auth = await OFFICE365.getToken();
    var places = await OFFICE365.getRoom(
      auth.access_token,request.params.email
    ).catch((error) => {});
    return places;
  },
  metadata: {
    id: "room",
    description: "Return room",
    validate: {},
  },
};

const rooms = {
  handler: async (request) => {
    var auth = await OFFICE365.getToken();
    var places = await OFFICE365.getRooms(
      auth.access_token
    ).catch((error) => {});
    return places;
  },
  metadata: {
    id: "rooms",
    description: "Return rooms",
    validate: {},
  },
};

const site = {
  handler: async (request) => {
    var auth = await OFFICE365.getToken();
    var places = await OFFICE365.getSite(
      auth.access_token,request.params.email
    ).catch((error) => {});
    return places;
  },
  metadata: {
    id: "site",
    description: "Return site",
    validate: {},
  },
};

const sites = {
  handler: async (request) => {
    var auth = await OFFICE365.getToken();
    var places = await OFFICE365.getSites(
      auth.access_token
    ).catch((error) => {});
    return places;
  },
  metadata: {
    id: "sites",
    description: "Return sites",
    validate: {},
  },
};

const ping = {
  handler: async (request) => {
    return "pong";
  },
  metadata: {
    id: "ping",
    description: "Alive signal",
    notes: "Use for testing",
    validate: {},
  },
};
const todaysBookings = {
  handler: async (request) => {
    var auth = await OFFICE365.getToken();
    var today = await OFFICE365.getTodaysBookings(
      auth.access_token,
      request.params.email
    ).catch((error) => {
      console.log(error);
    });
    return today;
  },
  metadata: {
    id: "room-display-today",
    description: "Reservations for a given room ",
    validate: {},
  },
};

const desktopSessions = {
  handler: async (request) => {
    var sessions = require("../logic/desktop").getSessions();
    return sessions;
  },
  metadata: {
    description: "All sessions with connected Desktops  ",

    validate: {},
  },
};

const winticate = {
  handler: async (request) => {
    var payload = request.payload;
    var fromIpAddress = request.headers["cf-connecting-ip"];
    var fromCountryCode = request.headers["cf-ipcountry"];
    var result = await require("../logic/auth").getTokenForWin(payload.email);
    return result.hasError
      ? Boom.forbidden(result.error)
      : { token: result.token, fromIpAddress, fromCountryCode };
  },
  metadata: {
    description: "Secure Token Server",
    notes: "Authentication point",
    validate: {},
  },
};

const book = {
  handler: async (request) => {
    var payload = request.payload;
    var fromIpAddress = request.headers["cf-connecting-ip"];
    var fromCountryCode = request.headers["cf-ipcountry"];
    var auth = await OFFICE365.getToken();
    var result = await OFFICE365.book(
      auth.access_token,
      request.params.upn,
      payload.startDateTime,
      payload.endDateTime,
      payload.timeZone
    );
    return result;
  },
  metadata: {
    description: "Book resources",
    tags: ["authenticated", "booking"],

    validate: {
      query: {
        upn: Joi.string()
          .email()
          .description("The address of the room / user "),
      },
    },
  },
};

const deleteBooking = {
  handler: async (request) => {
    var payload = request.payload;
    var fromIpAddress = request.headers["cf-connecting-ip"];
    var fromCountryCode = request.headers["cf-ipcountry"];
    var auth = await OFFICE365.getToken();
    var result = await OFFICE365.deleteBooking(
      auth.access_token,
      request.params.upn,
      request.params.id
    );
    return result;
  },
  metadata: {
    description: "Delete resource booking",

    validate: {},
  },
};

const extendBooking = {
  handler: async (request) => {
    var payload = request.payload;
    var fromIpAddress = request.headers["cf-connecting-ip"];
    var fromCountryCode = request.headers["cf-ipcountry"];
    var auth = await OFFICE365.getToken();
    var result = await OFFICE365.extendBooking(
      auth.access_token,
      request.params.upn,
      request.params.id,
      payload.endDateTime,
      payload.timeZone
    ).catch(e=>{
      console.log(e)
    })
    return result;
  },
  metadata: {
    description: "Extend Booking",
    tags: ["authenticated", "booking"],

    validate: {
      query: {
        upn: Joi.string()
          .email()
          .description("The address of the room / user "),
      },
    },
  },
};


module.exports.register = function (server) {
  return new Promise((resolve, reject) => {
    function get(path, logic) {
      server.route({
        //  config: { auth: 'simple' },
        method: "GET",
        path,
        options: {
          tags: ["api"],
          handler: logic.handler,
          ...logic.metadata,
        },
      });
    }

    function post(path, logic) {
      server.route({
        //   config: { auth: 'simple' },
        method: "POST",
        path,
        options: {
          tags: ["api"],
          handler: logic.handler,
          ...logic.metadata,
        },
      });
    }
    function postNoAuth(path, logic) {
      server.route({
        method: "POST",
        path,
        options: {
          tags: ["api"],
          auth: false,
          handler: logic.handler,
          ...logic.metadata,
        },
      });
    }
    function patchNoAuth(path, logic) {
      server.route({
        method: "PATCH",
        path,
        options: {
          tags: ["api"],
          auth: false,
          handler: logic.handler,
          ...logic.metadata,
        },
      });
    }
    function deleteNoAuth(path, logic) {
      server.route({
        method: "DELETE",
        path,
        options: {
          tags: ["api"],
          auth: false,
          handler: logic.handler,
          ...logic.metadata,
        },
      });
    }
    function getNoAuth(path, logic) {
      server.route({
        method: "GET",
        path,
        options: {
          tags: ["api"],
          auth: false,
          handler: logic.handler,
          ...logic.metadata,
        },
      });
    }


    postNoAuth("/v1.0/authenticate", authenticate);
    postNoAuth("/v1.0/winticate", winticate);
    getNoAuth("/ping", ping);
    getNoAuth("/places", places);

    postNoAuth("/v1.0/bookings/{upn}", book);
    deleteNoAuth("/v1.0/bookings/{upn}/{id}", deleteBooking);
    patchNoAuth("/v1.0/bookings/{upn}/{id}",extendBooking)

    get("/v1.0/desktop/sessions", desktopSessions);


    getNoAuth("/v1.0/rooms/{email}/todays-bookings", todaysBookings);
    getNoAuth("/v1.0/rooms/{email}", room);
    getNoAuth("/v1.0/rooms", rooms);
    getNoAuth("/v1.0/sites", sites);
    getNoAuth("/v1.0/sites/{email}", site);

    post("/v1.0/desktop", desktop);

    resolve();
  });
};
