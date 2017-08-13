import React from 'react';

import WardList from './../shared/ward_list';
import WardDetail from './ward_detail';

const MyWards = () => {
  return (
    <div>
      <h3>My Wards</h3>
      <WardList />
      <hr />
      <WardDetail />
    </div>
  );
};

export default MyWards;
