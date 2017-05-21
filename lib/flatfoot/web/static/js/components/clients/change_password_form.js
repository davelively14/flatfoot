import React, { Component } from 'react';
import { Field, reduxForm } from 'redux-form';
import { Link } from 'react-router';
import { renderField, renderFieldFocus } from '../helpers/render_field';

class ChangePasswordForm extends Component {
  render() {
    const { handleSubmit } = this.props;

    return(
      <form onSubmit={handleSubmit}>
        <Field name="currentPassword" component={renderFieldFocus} type="password" placeholder="Current Password" />
        <Field name="newPassword" component={renderField} type="password" placeholder="New Password" />
        <Field name="passwordConfirm" component={renderField} type="password" placeholder="Confirm New Password" />
        <hr />
        <button type="submit" className="btn btn-primary">Change Password</button>
      </form>
    );
  }
}

ChangePasswordForm = reduxForm({
  form: 'change_password'
})(ChangePasswordForm);

export default ChangePasswordForm;
