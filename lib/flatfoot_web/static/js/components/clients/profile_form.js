import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Field, reduxForm } from 'redux-form';
import { Link } from 'react-router';
import { renderFieldAndLabel, renderFieldAndLabelFocus, renderRange } from '../helpers/render_field';

const mapStateToProps = function (state) {
  return {
    initialValues: {
      username: state.user.username,
      email: state.user.email,
      globalThreshold: state.user.globalThreshold
    }
  };
};

class ProfileForm extends Component {
  render() {
    const { handleSubmit } = this.props;
    return(
      <form onSubmit={handleSubmit}>
        <Field name="username" type="text" component={renderFieldAndLabelFocus} placeholder="Username" />
        <Field name="email" type="email" component={renderFieldAndLabel} placeholder="Email" />
        <Field name="globalThreshold" type="range" component={renderRange} placeholder="Threshold" min="0" max="100" />
        <Field name="password" component={renderFieldAndLabel} type="password" placeholder="Password (required to change settings)" />
        <hr />
        <button type="submit" className="btn btn-primary">Update</button>
      </form>
    );
  }
}

ProfileForm = reduxForm({
  form: 'profile_form'
})(ProfileForm);

ProfileForm = connect(mapStateToProps, {})(ProfileForm);

export default ProfileForm;
