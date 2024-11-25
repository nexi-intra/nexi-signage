import React, { useState, useEffect } from "react";
import {Link} from "@reach/router"
import {
  getSites
} from "../logic/intranets-api";

import "./Rooms.css";
import TopNav from "../components/TopNav";
const Sites = (props) => {
  
  const [sites, setSites] = useState([]);

  useEffect(() => {
    async function run() {
    getSites().then(sites=>setSites(sites.value))      
    }
    run();
  }, []);

  const [error, setError] = useState("");
  return (
    <div>
    <TopNav />
    SITES
    <div>
    {sites.map((site,key)=>{

      return <div><Link to={"/sites/"+site.emailAddress}>{site.displayName}</Link></div>
      
    })}

    </div>
    </div>
  );
};

export default Sites;
