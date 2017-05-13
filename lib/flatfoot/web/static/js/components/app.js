import React from 'react';
import Header from './header/header';

const App = ({ children }) => (
  <div className="container">
    <Header />
    {children}
  </div>
);

export default App;
