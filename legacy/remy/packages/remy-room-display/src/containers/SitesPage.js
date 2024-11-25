import React, { useState, useEffect } from "react";
import {Link} from "@reach/router"
import {
  getSites
} from "../logic/intranets-api";

import "./Rooms.css";
import TopNav from "../components/TopNav";
const Sites = (props) => {
  
  const [sites, setSites] = useState([]);
  const [isApiOK, setIsApiOK] = useState(true);
  const [apiErrorCode, setApiErrorCode] = useState("");

  useEffect(() => {
    async function run() {
    getSites().then(sites=>setSites(sites.value)).catch(error=>{
      setApiErrorCode(error.message)
      setIsApiOK(false)
    });  
    }
    run();
  }, []);

  const [error, setError] = useState("");
  return (
    <div>
    <TopNav />
    SITES
    {!isApiOK && <div style={{color:"red",fontSize:"24px",padding:"20px"}}>

      {apiErrorCode} - You might not be connected from a trusted network
      </div>}
    <div>
    {sites.map((site,key)=>{

      return <div><Link to={"/sites/"+site.emailAddress}>{site.displayName}</Link></div>
      
    })}

    </div>
    </div>
  );
};

export default Sites;
