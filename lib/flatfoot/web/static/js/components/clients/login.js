import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import * as ActionCreators from '../../actions/index';

import Cookies from 'universal-cookie';
import { SubmissionError } from 'redux-form';
import LoginForm from './login_form';
import { fetchUser, fetchPhoenixToken, uri } from '../helpers/api';

const mapStateToProps = function (state) {
  return {
    user: state.user
  };
};

const mapDispatchToProps = function (dispatch) {
  return bindActionCreators(ActionCreators, dispatch);
};

class Login extends Component {
  submit(values) {
    const { setUser, setToken, setPhoenixToken } = this.props;

    switch (true) {
      case values.username == undefined:
        throw new SubmissionError({
          username: 'Username cannot be blank',
          _error: 'Invalid username'
        });
      case values.password == undefined:
        throw new SubmissionError({
          password: 'Password cannot be blank',
          _error: 'Invalid password'
        });
      default:
        return fetch(uri + 'api/login?user_params[username]=' + values.username + '&user_params[password]=' + values.password, {
          method: 'post'
        }).then(
          function(response) {
            if (response.status == 401) {
              throw new SubmissionError({
                password: 'Username or password is incorrect',
                _error: 'Invalid credentials'
              });
            }
            return response.text();
          }
        ).then(
          function(text) {
            let token = JSON.parse(text).data.token;
            const cookies = new Cookies();
            cookies.set('token', token, {
              path: '/'
            });

            setToken(token);
            fetchUser(setUser, token);
            fetchPhoenixToken(setPhoenixToken, token);
            browserHistory.push('/dashboard');
          }
        );
    }

  }

  render() {
    return (
      <div className="row">
        <div className="col-sm-3" />
        <div className="col-sm-6">
          <h2>Login</h2>
          <div className="form-group">
            <LoginForm onSubmit={this.submit.bind(this)} />
          </div>
        </div>
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Login);
