import React, { Component } from 'react';
import { Field, reduxForm } from 'redux-form';
import { Link } from 'react-router';

const renderField = ({input, placeholder, type, meta: {touched, error}}) => (
  <div className="form-group">
    <div>
      <input {...input} placeholder={placeholder} type={type} className="form-control" />
      {touched && error && <span>{error}</span>}
    </div>
  </div>
);

const renderFieldFocus = ({input, placeholder, type, meta: {touched, error}}) => (
  <div className="form-group">
    <div>
      <input {...input} placeholder={placeholder} type={type} className="form-control" autoFocus />
      {touched && error && <span>{error}</span>}
    </div>
  </div>
);

class NewUserForm extends Component {
  render() {
    const { handleSubmit } = this.props;

    return(
      <form onSubmit={ handleSubmit }>
        <Field name="username" type="text" component={renderFieldFocus} placeholder="Username" />
        <Field name="email" type="email" component={renderField} placeholder="Email" />
        <Field name="password" component={renderField} type="password" placeholder="Password" />
        <Field name="passwordConfirm" component={renderField} type="password" placeholder="Confirm Password" />

        <button type="submit" className="btn btn-primary">Submit</button>
        <Link to="/" className="btn btn-danger pull-right">Cancel</Link>
      </form>
    );
  }
}

NewUserForm = reduxForm({
  form: 'new_user'
})(NewUserForm);

export default NewUserForm;
