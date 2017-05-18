import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import * as ActionCreators from '../../actions/index';
import { fetchUser, fetchSettings } from '../api';

const mapStateToProps = function (state) {

  return {
    user: state.user,
    settings: state.settings,
    // TODO uncomment dev cheat, delete hardcoded session and logged_in
    // session: state.session,
    // logged_in: state.session.token ? true : false
    logged_in: true,
    session: {token: 'VjdjNnlXOG1GTFoxY2xqV0lLTUlIZz09'}
  };
};

const mapDispatchToProps = function (dispatch) {
  return bindActionCreators(ActionCreators, dispatch);
};

class Profile extends Component {

  // If not logged_in, will redirect to root
  // TODO if not logged_in, check cookies before redirecting
  componentWillMount() {
    this.props.logged_in ? null : browserHistory.push('/');
  }

  // Load data after component mounts
  componentDidMount() {
    let { setUser, setSettings } = this.props;
    let token = this.props.session.token;

    fetchUser(setUser, token);
    fetchSettings(setSettings, token);
  }

  render() {
    return (
      <div className="row">
        <h2>Profile</h2>
        <div className="col-sm-4">
          <h4>{this.props.user.username}</h4>
          <p>{this.props.user.email}</p>
          <p>Global threshold: {this.props.settings.globalThreshold}</p>
          <button className="btn btn-primary btn-sm">Edit</button>
        </div>
        <div className="col-sm-8">
          
        </div>
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Profile);
