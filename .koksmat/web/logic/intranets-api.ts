import axios, { AxiosRequestConfig } from 'axios';
import _ from 'lodash';
import { Room, Booking, Site } from '../types/room-display';

const host = "https://nets-intranets-api.azurewebsites.net";

async function callAxios<T>(config: AxiosRequestConfig): Promise<T> {
  try {
    const response = await axios(config);
    return response.data;
  } catch (error) {
    throw error;
  }
}

export async function getRoomBookingsForToday(email: string): Promise<{ value: Booking[] }> {
  const config: AxiosRequestConfig = {
    method: 'get',
    url: `${host}/v1.0/rooms/${email}/todays-bookings`,
    headers: {},
  };

  return callAxios<{ value: Booking[] }>(config);
}

export async function getRoom(email: string): Promise<Room> {
  const config: AxiosRequestConfig = {
    method: 'get',
    url: `${host}/v1.0/rooms/${email}`,
    headers: {},
  };

  return callAxios<Room>(config);
}

export async function getRooms(): Promise<{ value: Room[] }> {
  const config: AxiosRequestConfig = {
    method: 'get',
    url: `${host}/v1.0/rooms`,
    headers: {},
  };

  const result = await callAxios<{ value: Room[] }>(config);
  result.value = _.sortBy(result.value, ['displayName']);
  return result;
}

export async function getSites(): Promise<{ value: Site[] }> {
  const config: AxiosRequestConfig = {
    method: 'get',
    url: `${host}/v1.0/sites`,
    headers: {},
  };

  const result = await callAxios<{ value: Site[] }>(config);
  result.value = _.sortBy(result.value, ['displayName']);
  return result;
}

export async function getSiteRooms(email: string): Promise<{ value: Room[] }> {
  const config: AxiosRequestConfig = {
    method: 'get',
    url: `${host}/v1.0/sites/${email}`,
    headers: {},
  };

  const result = await callAxios<{ value: Room[] }>(config);
  result.value = _.sortBy(result.value, ['displayName']);
  return result;
}

export async function addBooking(email: string, startDateTime: string, endDateTime: string, timeZone?: string): Promise<Booking> {
  const data = { startDateTime, endDateTime, timeZone: timeZone || 'UTC' };

  const config: AxiosRequestConfig = {
    method: 'post',
    url: `${host}/v1.0/bookings/${email}`,
    headers: {
      'Content-Type': 'application/json',
    },
    data: data,
  };

  return callAxios<Booking>(config);
}

export async function deleteBooking(email: string, id: string): Promise<void> {
  const config: AxiosRequestConfig = {
    method: 'delete',
    url: `${host}/v1.0/bookings/${email}/${id}`,
    headers: {
      'Content-Type': 'application/json',
    },
  };

  return callAxios<void>(config);
}

export async function extendBooking(email: string, id: string, endDateTime: string, timeZone?: string): Promise<Booking> {
  const data = { endDateTime, timeZone: timeZone || 'UTC' };
  const config: AxiosRequestConfig = {
    method: 'patch',
    url: `${host}/v1.0/bookings/${email}/${id}`,
    headers: {
      'Content-Type': 'application/json',
    },
    data: data,
  };

  return callAxios<Booking>(config);
}

