import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import * as ActionCreators from '../actions/index';

const mapStateToProps = function (state) {
  return {
    user: state.user,
    session: state.session,
    logged_in: state.session.token ? true : false
  };
};

const mapDispatchToProps = function (dispatch) {
  return bindActionCreators(ActionCreators, dispatch);
};

class Settings extends Component {

  // If not logged_in, will redirect to root
  // componentWillMount() {
  //   this.props.logged_in ? null : browserHistory.push('/');
  // }

  // For development only
  componentWillMount() {
    this.props.setUser('dlively', 'dlively@resurgens.io');
    this.props.setToken('dVlOYzlWQ2tkbEdUOGxYVFRxZkRpZz09');
  }

  // Load data after component mounts
  // TODO stopped: fetch user info and settings.
  componentDidMount() {

  }

  render() {
    return (
      <div className="row">
        <h2>Settings</h2>
        <div className="col-sm-4">
          <h4>{this.props.user.username}</h4>
          <p>{this.props.user.email}</p>
        </div>
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Settings);
