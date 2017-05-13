import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import * as ActionCreators from '../actions/index';

const mapStateToProps = function (state) {
  return {
    user: state.user,
    session: state.session
  };
};

const mapDispatchToProps = function (dispatch) {
  return bindActionCreators(ActionCreators, dispatch);
};

class Settings extends Component {
  render() {
    return (
      <div className="row">
        <h2>Settings</h2>
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Settings);
