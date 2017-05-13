import React from 'react';

export const renderField = ({input, placeholder, type, meta: {touched, error}}) => (
  <div className="form-group">
    <div>
      <input {...input} placeholder={placeholder} type={type} className="form-control" />
      {touched && error && <span>{error}</span>}
    </div>
  </div>
);

export const renderFieldFocus = ({input, placeholder, type, meta: {touched, error}}) => (
  <div className="form-group">
    <div>
      <input {...input} placeholder={placeholder} type={type} className="form-control" autoFocus />
      {touched && error && <span>{error}</span>}
    </div>
  </div>
);