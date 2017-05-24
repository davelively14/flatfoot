import React, { Component } from 'react';
import { connect } from 'react-redux';

import Header from './header/header';

const mapStateToProps = function(_state) {
  return {
    cookies: undefined
  };
};

class App extends Component {
  render() {
    return (
      <div className="container">
        <Header />
        {this.props.children}
      </div>
    );
  }
}

export default connect(mapStateToProps, {})(App);
