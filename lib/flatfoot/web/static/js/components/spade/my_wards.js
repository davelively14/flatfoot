import React from 'react';

import WardList from './ward_list';
import WardFocus from './ward_focus';

const MyWards = () => {
  return (
    <div>
      <h3>My Wards</h3>
      <WardList />
      <hr />
      <WardFocus />
    </div>
  );
};

export default MyWards;
