import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import * as ActionCreators from '../../actions/index';

import { fetchUser, updateUser, validateUser, uri } from '../helpers/api';
import { SubmissionError } from 'redux-form';
import ProfileForm from './profile_form';
import ChangePasswordForm from './change_password_form';

const mapStateToProps = function (state) {

  return {
    user: state.user,
    ui: state.ui,
    session: state.session,
    loggedIn: state.session.token ? true : false
  };
};

const mapDispatchToProps = function (dispatch) {
  return bindActionCreators(ActionCreators, dispatch);
};

class Profile extends Component {

  // If not loggedIn, will redirect to root
  componentWillMount() {
    this.props.loggedIn ? null : browserHistory.push('/');
  }

  submitProfileEdit(values) {
    const { setUser, toggleUserEdit } = this.props;
    const token = this.props.session.token;

    let headers = new Headers();
    headers.append('Authorization', 'Token token="' + token + '"');

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
        return fetch(uri + 'api/users/validate?username=' + this.props.user.username + '&password=' + values.password, {
          method: 'get',
          headers: headers
        }).then(
          function(response) {
            if (response.status != 200) {
              throw 'Invalid parameters. Must pass username and password.';
            }

            return response.text();
          }
        ).then(
          function(text) {
            let result = JSON.parse(text);

            if (result.authorized) {
              let userParams = {
                username: values.username,
                email: values.email,
                global_threshold: values.globalThreshold
              };

              updateUser(setUser, toggleUserEdit, token, userParams);
            } else {
              throw new SubmissionError({
                password: 'Invalid password',
                _error: 'Password is incorrect'
              });
            }
          }
        );
    }
  }

  submitPasswordChange(values) {
    const { toggleChangePassword, setUser } = this.props;
    const token = this.props.session.token;

    let headers = new Headers();
    headers.append('Authorization', 'Token token="' + token + '"');

    switch (true) {
      case !values.currentPassword:
        throw new SubmissionError({
          currentPassword: 'Must include the current password',
          _error: 'Invalid password'
        });
      case !values.newPassword || values.newPassword.length < 6:
        throw new SubmissionError({
          newPassword: 'New password must be at least 6 characters',
          _error: 'Password too short'
        });
      case values.newPassword != values.passwordConfirm:
        throw new SubmissionError({
          newPassword: 'New password and confirmation do not match',
          _error: 'Passwords do not match'
        });
      default:
        return fetch(uri + 'api/users/validate?username=' + this.props.user.username + '&password=' + values.currentPassword, {
          method: 'get',
          headers: headers
        }).then(
          function(response) {
            if (response.status != 200) {
              throw 'Invalid parameters. Must pass username and password.';
            }

            return response.text();
          }
        ).then(
          function(text) {
            let result = JSON.parse(text);

            if (result.authorized) {
              let userParams = {
                new_password: values.newPassword,
                current_password: values.currentPassword
              };

              updateUser(setUser, toggleChangePassword, token, userParams);
            } else {
              throw new SubmissionError({
                currentPassword: 'Provided current password is incorrect',
                _error: 'Password is incorrect'
              });
            }
          }
        );
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
            <button onClick={this.props.toggleUserEdit} className="btn btn-primary btn-sm">Edit Profile</button>
          }
          <br />
          {this.props.ui.showChangePassword &&
            <a onClick={this.props.toggleChangePassword} className="text-link"><i><small>Cancel</small></i></a>
            ||
            <a onClick={this.props.toggleChangePassword} className="text-link"><i><small>Change password</small></i></a>
          }
        </div>
        <div className="col-sm-8">
          {this.props.ui.showUserEdit &&
            <ProfileForm onSubmit={this.submitProfileEdit.bind(this)} enableReinitialize="true" />
          }
          {this.props.ui.showChangePassword &&
            <ChangePasswordForm onSubmit={this.submitPasswordChange.bind(this)} />
          }
        </div>
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Profile);
