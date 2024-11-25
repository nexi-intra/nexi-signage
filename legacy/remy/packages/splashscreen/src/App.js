import React from "react";
import HomePage from "./containers/HomePage";
import SplashPage from "./containers/SplashPage";
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
      <div className="  min-height-100">
        <Router>
          <SplashPage path="/" />

        </Router>
      </div>
    </div>
  );
}

export default App;
