import React from 'react';

import Profile from './profile';
import WardList from './../shared/ward_list';
import ActivityFeed from './../shared/activity_feed';

const Overview = () => {
  return (
    <div className="row">
      <div className="col-sm-4">
        <Profile />
      </div>
      <div className="col-sm-8">
        <h3>Wards</h3>
        <WardList />
        <hr />
        <ActivityFeed noProps={true} />
      </div>
    </div>
  );
};

export default Overview;
