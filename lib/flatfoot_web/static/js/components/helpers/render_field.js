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

export const renderFieldAndLabel = ({input, placeholder, type, meta: {touched, error}}) => (
  <div className="form-group">
    <div>
      <label>{placeholder}</label>
      <input {...input} placeholder={placeholder} type={type} className="form-control" />
      {touched && error && <span>{error}</span>}
    </div>
  </div>
);

export const renderFieldAndLabelFocus = ({input, placeholder, type, meta: {touched, error}}) => (
  <div className="form-group">
    <div>
      <label>{placeholder}</label>
      <input {...input} placeholder={placeholder} type={type} className="form-control" autoFocus />
      {touched && error && <span>{error}</span>}
    </div>
  </div>
);

export const renderRange = ({input, placeholder, min, max, meta: {touched, error}}) => (
  <div className="form-group">
    <div>
      <label>{placeholder}</label>
      <input {...input} type="range" min={min} max={max} className="form-control" />
      {touched && error && <span>{error}</span>}
    </div>
  </div>
);
