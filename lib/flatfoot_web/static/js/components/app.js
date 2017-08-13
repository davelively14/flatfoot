import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../actions/index';
import Cookies from 'universal-cookie';
import { fetchUser, fetchPhoenixToken } from './helpers/api';

import Header from './header/header';

const mapStateToProps = function(state) {
  return {
    loggedIn: state.session.token ? true : false
  };
};

const mapDispatchToProps = function(dispatch) {
  return bindActionCreators(ActionCreators, dispatch);
};

class App extends Component {
  componentWillMount() {
    const cookies = new Cookies();

    if (!this.props.loggedIn && cookies.get('token')) {
      let token = cookies.get('token');

      this.props.setToken(token);
      fetchUser(this.props.setUser, token);
      fetchPhoenixToken(this.props.setPhoenixToken, token);
    }
  }

  render() {
    return (
      <div className="container">
        <Header />
        {this.props.children}
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(App);
