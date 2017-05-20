import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import * as ActionCreators from '../../actions/index';

import { fetchUser, updateUser, uri } from '../helpers/api';
import { SubmissionError } from 'redux-form';
import ProfileForm from './profile_form';

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
    let headers = new Headers();
    headers.append('Authorization', 'Token token="' + this.props.session.token + '"');

    const { setUser, toggleUserEdit } = this.props;
    const token = this.props.session.token;

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
        // return validateUser(this.props.session.token, this.props.user.username, values.password);
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
