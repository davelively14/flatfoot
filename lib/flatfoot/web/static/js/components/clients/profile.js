import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import * as ActionCreators from '../../actions/index';
import { fetchUser, fetchSettings } from '../helpers/api';

import { SubmissionError } from 'redux-form';
import ProfileForm from './profile_form';

const mapStateToProps = function (state) {

  return {
    user: state.user,
    settings: state.settings,
    ui: state.ui,
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

  submit(values) {
    switch (true) {
      case !values.username:
        throw new SubmissionError({
          username: 'Username cannot be blank',
          _error: 'Invalid username'
        });
      case values.email == undefined:
        throw new SubmissionError({
          email: 'Email cannot be blank',
          _error: 'Invalid email'
        });
      case values.password == undefined:
        throw new SubmissionError({
          password: 'Must include a valid password to change values',
          _error: 'Invalid password'
        });
      default:
        console.log(values);
    }
  }

  render() {
    return (
      <div className="row">
        <h2>Profile</h2>
        <div className="col-sm-4">
          <h4>{this.props.user.username}</h4>
          <p>{this.props.user.email}</p>
          <p>Global threshold: {this.props.settings.globalThreshold}</p>
          {this.props.ui.showUserEdit &&
            <button onClick={this.props.toggleUserEdit} className="btn btn-danger btn-sm">Cancel Edit</button>
            ||
            <button onClick={this.props.toggleUserEdit} className="btn btn-primary btn-sm">Edit</button>
          }
          <br />
          <i><small>Change password (soon)</small></i>
        </div>
        <div className="col-sm-8">
          {this.props.ui.showUserEdit &&
            <ProfileForm onSubmit={this.submit.bind(this)} enableReinitialize="true" />
          }
        </div>
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Profile);
