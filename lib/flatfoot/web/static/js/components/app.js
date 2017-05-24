import React from 'react';
import { connect } from 'react-redux';

import Header from './header/header';

const mapStateToProps = function(_state) {
  return {
    cookies: undefined
  };
};

const App = ({ children }) => (
  <div className="container">
    <Header />
    {children}
  </div>
);

export default connect(mapStateToProps, {})(App);
