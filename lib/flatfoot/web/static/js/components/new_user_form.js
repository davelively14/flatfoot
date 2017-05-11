import React, { Component } from 'react';
import { Field, reduxForm } from 'redux-form';
import { Link } from 'react-router';

class NewUserForm {
  render() {
    const { handleSubmit } = this.props;

    return(
      <form onSubmit={ handleSubmit }>

      </form>
    );
  }
}
