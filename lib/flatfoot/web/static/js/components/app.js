import React from 'react';
import { Link } from 'react-router';

import Header from './header/header';

const App = ({ children }) => (
  <div className="container">
    <Header />
    {children}
  </div>
);

export default App;
