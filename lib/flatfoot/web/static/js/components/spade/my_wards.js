import React from 'react';

import WardList from './ward_list';
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
