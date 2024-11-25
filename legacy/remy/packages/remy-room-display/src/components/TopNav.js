import React from 'react';
import { Link } from '@reach/router';

function TopNav(props) {
    return (
        <div style={{ display: "flex" }}>
        <div style={{ padding: 10 }}>
          <Link to="/sites">Sites</Link>
        </div>
        <div style={{ padding: 10 }}>

        
          <Link to="/room">Rooms</Link>
        </div>
      </div>
    );
}

export default TopNav;