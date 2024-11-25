import React from "react";
import HomePage from "./containers/HomePage";
import RoomDisplay from "./containers/RoomDisplayPage";
import Rooms from "./containers/RoomsPage";
import Room from "./containers/RoomPage";
import Sites from "./containers/SitesPage";
import Site from "./containers/SitePage";
import "./App.css";
import { Router, Link } from "@reach/router";
import TopNav from "./components/TopNav";
function App() {
  const Home = () => {
    return <TopNav />
  };
  return (
    <div className="section min-height-100">
      <div className="container  min-height-100">
        <Router>
          <Home path="/" />
          <Sites path="/sites" />
          <Site path="/sites/:email" />

          <Rooms path="/room" />
          <Room path="/room/:email" />
          <RoomDisplay path="/room/:email/display" timezone="Europe/Berlin"/>
          <RoomDisplay path="/room/:email/display/:timezone" />
        </Router>
      </div>
    </div>
  );
}

export default App;
