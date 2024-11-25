'use strict';
require("dotenv").config();
const Hapi = require('@hapi/hapi');
const fs = require('fs-extra');
const path = require('path');

var dataStore = process.env.BUZZSTORE

function getState(upn) {
    try {

        return fs.readJSONSync(path.join(dataStore, upn + ".state.json"))
    } catch (error) {
        return { machines: [] }
    }

}

function setState(upn, data) {
    fs.writeJSONSync(path.join(dataStore, upn + ".state.json"), data)
    return 0

}

const init = async () => {

    const server = Hapi.server({
        port: process.env.port || 1234,
        host: 'localhost'
    });
    server.route({
        method: 'GET',
        path: '/',
        handler: (request, h) => {
            var username = request.headers['x-iisnode-auth_user'];
            var authenticationType = request.headers['x-iisnode-auth_type'];
            return username 
        }
    });
    server.route({
        method: 'GET',
        path: '/state/{upn}',
        handler: async (request, h) => {

            return getState(request.params.upn);
        }
    });

    server.route({
        method: 'GET',
        path: '/state',
        handler: async (request, h) => {
            var username = request.headers['x-iisnode-auth_user'];
            var upn = username.replace("CORP\\", "") + "@nets.eu"

            return getState(upn);
        }
    });


    server.route({
        method: 'POST',
        path: '/state',
        handler: async (request, h) => {
            const payload = request.payload;
            var username = request.headers['x-iisnode-auth_user'];
            var upn = username.replace("CORP\\", "") + "@nets.eu"
            return setState(upn, payload);
        }
    });

    await server.start();
    console.log('Server running on %s', server.info.uri);
};

process.on('unhandledRejection', (err) => {

    console.log(err);
    //process.exit(1);
});

init();