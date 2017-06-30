import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import * as ActionCreators from '../../actions/index';

import { SubmissionError } from 'redux-form';
import NewUserForm from './new_user_form';
import { uri } from '../helpers/api'

const mapStateToProps = function (state) {
  return {
    user: state.user
  };
};

const mapDispatchToProps = function (dispatch) {
  return bindActionCreators(ActionCreators, dispatch);
};

class NewUser extends Component {
  submit (values) {
    const {setUser, setToken} = this.props;

    switch (true) {
      case values.username == undefined:
        throw new SubmissionError({
          username: 'Username cannot be blank',
          _error: 'Invalid username'
        });
      case values.email == undefined:
        throw new SubmissionError({
          email: 'Email cannot be blank',
          _error: 'Invalid email'
        });
      case !values.password || values.password.length < 6:
        throw new SubmissionError({
          password: 'Password must be at least 6 characters',
          _error: 'Password too short'
        });
      case values.password != values.passwordConfirm:
        throw new SubmissionError({
          password: 'Password and confirmation do not match',
          _error: 'Passwords do not match'
        });
      default:
        return fetch(uri + 'api/new_user?user_params[username]=' + values.username + '&user_params[password]='+ values.password + '&user_params[email]=' + values.email, {
          method: 'post'
        }).then(
          function(response) {
            if (response.status == 422) {
              throw new SubmissionError({
                username: 'Username or email are already taken',
                _error: 'Username or email not unique'
              });
            }
            return response.text();
          }
        ).then(
          function(text) {
            setUser(undefined, values.username, values.email);
            setToken(JSON.parse(text).data.token);
            browserHistory.push('/');
          }
        );

    }
  }

  render() {
    return(
      <div className="row">
        <div className="col-sm-3" />
        <div className="col-sm-6">
          <h2>New User</h2>
          <div className="form-group">
            <NewUserForm onSubmit={this.submit.bind(this)} />
          </div>
        </div>
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(NewUser);
