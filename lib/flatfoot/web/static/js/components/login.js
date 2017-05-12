import React, { Component } from 'react';
import LoginForm from './login_form'

class Login extends Component {
  submit(values) {
    console.log('Username: ' + values.username + ', Password: ' + values.password);
  }

  render() {
    return (
      <div className="row">
        <div className="col-sm-3" />
        <div className="col-sm-6">
          <h2>Login</h2>
          <div className="form-group">
            <LoginForm onSubmit={this.submit} />
          </div>
        </div>
      </div>
    );
  }
}

export default Login;
