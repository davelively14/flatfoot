import React from 'react';
import LoginForm from './login_form'

const Login = () => (
  <div className="row">
    <div className="col-sm-3" />
    <div className="col-sm-6">
      <h2>Login</h2>
      <div className="form-group">
        <LoginForm />
      </div>
    </div>
  </div>
);

export default Login;
