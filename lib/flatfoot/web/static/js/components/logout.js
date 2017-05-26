import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import * as ActionCreators from '../actions/index';

const mapStateToProps = function (_state) {
  return {

  };
};

const mapDispatchToProps = function (dispatch) {
  return bindActionCreators(ActionCreators, dispatch);
};

class Logout extends Component {
  componentDidMount() {
    this.props.logout();
    browserHistory.push('/');
  }

  render() {
    return null;
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Logout);
