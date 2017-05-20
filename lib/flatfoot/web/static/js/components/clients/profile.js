import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import * as ActionCreators from '../../actions/index';
import { fetchUser } from '../helpers/api';

import { SubmissionError } from 'redux-form';
import ProfileForm from './profile_form';
import { updateUser } from '../helpers/api';

const mapStateToProps = function (state) {

  return {
    user: state.user,
    ui: state.ui,
    // TODO uncomment dev cheat, delete hardcoded session and logged_in
    // logged_in: state.session.token ? true : false
    logged_in: true,
    session: {token: 'MUxQODlhWlZHdm5FUjZGekdDZkUwdz09'}
  };
};

const mapDispatchToProps = function (dispatch) {
  return bindActionCreators(ActionCreators, dispatch);
};

class Profile extends Component {

  // If not logged_in, will redirect to root
  // TODO if not logged_in, check cookies before redirecting, fetchUser
  componentWillMount() {
    this.props.logged_in ? null : browserHistory.push('/');
  }

  // Load data after component mounts
  componentDidMount() {
    // TODO delete dev cheat
    fetchUser(this.props.setUser, this.props.session.token);
  }

  submit(values) {
    switch (true) {
      case !values.username:
        throw new SubmissionError({
          username: 'Username cannot be blank',
          _error: 'Invalid username'
        });
      case !values.email:
        throw new SubmissionError({
          email: 'Email cannot be blank',
          _error: 'Invalid email'
        });
      case !values.password:
        throw new SubmissionError({
          password: 'Must include a valid password to change values',
          _error: 'Invalid password'
        });
      default:
        console.log(updateUser(this.props.setUser, this.props.session.token, {username: values.username}));
    }
  }

  render() {
    return (
      <div className="row">
        <h2>Profile</h2>
        <div className="col-sm-4">
          <h4>{this.props.user.username}</h4>
          <p>{this.props.user.email}</p>
          <p>Global threshold: {this.props.user.globalThreshold}</p>
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
