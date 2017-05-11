import React, {Component} from 'react';
import {Field, reduxForm} from 'redux-form';
import {Link} from 'react-router';

class LoginForm extends Component {
  render() {
    const {handleSubmit} = this.props;
    return(
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          {/* <label htmlFor="username">Username</label> */}
          <Field name="username" component="input" type="text" className="form-control" placeholder="Username" autoFocus />
        </div>
        <div className="form-group">
          {/* <label htmlFor="password">Password</label> */}
          <Field name="password" component="input" type="password" className="form-control" placeholder="Password" />          
        </div>
        <button type="submit" className="btn btn-primary">Submit</button>
        <Link to="/" className="btn btn-danger pull-right">Cancel</Link>
      </form>
    );
  }
}

LoginForm = reduxForm({
  form: 'login'
})(LoginForm);

export default LoginForm;
