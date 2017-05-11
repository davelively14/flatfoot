import React from 'react';
import { Link } from 'react-router';

const Landing = () => {
  return (
    <div>
      <div className="row">
        <div className="col-sm-1" />
        <div className="col-sm-10">
          <div className="jumbotron">
            <h1>Flatfoot</h1>
            <h2><small>Know if someone you care about is being bullied</small></h2>
          </div>
        </div>
        <div className="col-sm-1" />
      </div>
      <div className="row">
        <div className="col-xs-6 text-center">
          <Link to="new-user">
            <button className="btn btn-primary">New User</button>
          </Link>
        </div>
        <div className="col-xs-6 text-center">
          <Link to="login">
            <button className="btn btn-primary">Login</button>
          </Link>
        </div>
      </div>
    </div>
  );
};

export default Landing;
