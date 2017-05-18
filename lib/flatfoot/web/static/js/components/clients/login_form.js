import React, { Component } from 'react';
import { Field, reduxForm } from 'redux-form';
import { Link } from 'react-router';
import { renderField, renderFieldFocus } from '../helpers/render_field';

class LoginForm extends Component {
  render() {
    const { handleSubmit } = this.props;
    return(
      <form onSubmit={handleSubmit}>
        <Field name="username" component={renderFieldFocus} type="text" className="form-control" placeholder="Username" autoFocus />
        <Field name="password" component={renderField} type="password" className="form-control" placeholder="Password" />
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
