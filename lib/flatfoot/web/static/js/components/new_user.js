import React from 'react';
import NewUserForm from './new_user_form';

const Login = () => (
  <div className="row">
    <div className="col-sm-3" />
    <div className="col-sm-6">
      <h2>New User</h2>
      <div className="form-group">
        <NewUserForm />
      </div>
    </div>
  </div>
);

export default Login;
