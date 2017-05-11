import React, { Component } from 'react';
import { Field, reduxForm } from 'redux-form';
import { Link } from 'react-router';

class NewUserForm extends Component {
  render() {
    const { handleSubmit } = this.props;

    return(
      <form onSubmit={ handleSubmit }>
        <div className="form-group">
          <Field name="username" component="input" type="text" className="form-control" placeholder="Username" autoFocus />
          {/* <Field name="username" component={username =>
            <div>
              <input type="text" {...username} placeholder="Username" />
              {username.touched && username.error && <span>{username.error}</span>}
            </div>
          } /> */}
        </div>
        <div className="form-group">
          <Field name="password" component="input" type="password" className="form-control" placeholder="Password" />
        </div>
        <div className="form-group">
          <Field name="password-confirm" component="input" type="password" className="form-control" placeholder="Confirm Password" />
        </div>
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
