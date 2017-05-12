import React, { Component } from 'react';
import NewUserForm from './new_user_form';
import { SubmissionError } from 'redux-form';

class Login extends Component {
  submit (values) {
    switch (true) {
      case values.username == undefined:
        throw new SubmissionError({
          username: 'Username cannot be blank',
          _error: 'Invalid username'
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
        console.log('Submited. Username: ' + values.username + ', password: ' + values.password);
    }
  }

  render() {
    return(
      <div className="row">
        <div className="col-sm-3" />
        <div className="col-sm-6">
          <h2>New User</h2>
          <div className="form-group">
            <NewUserForm onSubmit={this.submit} />
          </div>
        </div>
      </div>
    );
  }
}

export default Login;
