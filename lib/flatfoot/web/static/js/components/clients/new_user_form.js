import React, { Component } from 'react';
import { Field, reduxForm } from 'redux-form';
import { Link } from 'react-router';
import { renderField, renderFieldFocus } from '../helpers/render_field';

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
