import modalForm from '../../../lib/flatfoot_web/static/js/reducers/modal_form';

var initialState = {
  formValues: undefined,
  formErrors: undefined
};

const SET_FORM_VALUES = 'SET_FORM_VALUES', CLEAR_FORM_VALUES = 'CLEAR_FORM_VALUES', SET_FORM_ERRORS = 'SET_FORM_ERRORS', CLEAR_FORM_ERRORS = 'CLEAR_FORM_ERRORS', ADD_FORM_ERROR = 'ADD_FORM_ERROR', ADD_FORM_VALUE = 'ADD_FORM_VALUE', CLOSE_FORM_MODAL = 'CLOSE_FORM_MODAL';

describe('modalForm', () => {
  it('should set default state to initialState', () => {
    expect(modalForm(undefined, {})).to.eql(initialState);
  });

  it('should return current state by default', () => {
    let state = Object.assign({}, initialState, {formValues: 'asdf'});
    expect(modalForm(state, {type: 'NO_LEGIT_TYPE'})).to.eql(state);
  });

  it('should set formValues to the passed form_values object with SET_FORM_VALUES type', () => {
    expect(modalForm(initialState, {type: SET_FORM_VALUES, form_values: {name: 'dave'}}).formValues).to.eql({name: 'dave'});
  });

  it('should set formValues to undefined with SET_FORM_VALUES type and no form_values param', () => {
    expect(modalForm(initialState, {type: SET_FORM_VALUES}).formValues).to.be.undefined;
  });

  it('should add a key value pair to an existing formValues object when provided ADD_FORM_VALUE type, key and value', () => {
    let startState = Object.assign({}, initialState, {formValues: {name: 'dave'}});
    let endState = Object.assign({}, startState, {formValues: {name: 'dave', email: 'd@lively.com'}});
    expect(modalForm(startState, {type: ADD_FORM_VALUE, key: 'email', value: 'd@lively.com'})).to.eql(endState);
  });

  it('should not add a new KV pair when provided ADD_FORM_VALUE type and missing either key or value param', () => {
    let startState = Object.assign({}, initialState, {formValues: {name: 'dave'}});
    expect(modalForm(startState, {type: ADD_FORM_VALUE, value: 'd@lively.com'}).formValues).to.eql(startState.formValues);
    expect(modalForm(startState, {type: ADD_FORM_VALUE, key: 'email'}).formValues).to.eql(startState.formValues);
  });

  it('should set formErrors when passed form_errors object and SET_FORM_ERRORS type', () => {
    expect(modalForm(initialState, {type: SET_FORM_ERRORS, form_errors: {name: 'Cannot be blank'}}).formErrors).to.eql({name: 'Cannot be blank'});
  });

  it('should set formErrors to undefined with SET_FORM_ERRORS type and no form_errors param', () => {
    expect(modalForm(initialState, {type: SET_FORM_ERRORS}).formErrors).to.be.undefined;
  });

  it('should set formErrors to undefined with CLEAR_FORM_ERRORS type', () => {
    let startState = Object.assign({}, initialState, {formErrors: {name: 'jon smith'}});
    expect(startState.formErrors).to.eql({name: 'jon smith'});
    expect(modalForm(startState, {type: CLEAR_FORM_ERRORS}).formErrors).to.be.undefined;
  });

  it('should add a KV pair to formErrors with ADD_FORM_ERROR type, key, and value', () => {
    let startState = Object.assign({}, initialState, {formErrors: {name: 'Cannot be blank'}});
    let endState = Object.assign({}, initialState, {formErrors: {name: 'Cannot be blank', email: 'Incorrect format'}});
    expect(modalForm(startState, {type: ADD_FORM_ERROR, key: 'email', value: 'Incorrect format'})).to.eql(endState);
  });

  it('should not add a new KV pair when provided ADD_FORM_ERROR type and missing either key or value param', () => {
    let startState = Object.assign({}, initialState, {formErrors: {name: 'Cannot be blank'}});
    expect(modalForm(startState, {type: ADD_FORM_ERROR, value: 'Incorrect format'}).formErrors).to.eql(startState.formErrors);
    expect(modalForm(startState, {type: ADD_FORM_ERROR, key: 'email'}).formErrors).to.eql(startState.formErrors);
  });

  it('should clear all values and set state to initialState with CLEAR_FORM_VALUES or CLOSE_FORM_MODAL type', () => {
    let startState = Object.assign({}, initialState, {formValues: 'formValues', formErrors: 'formErrors'});
    expect(modalForm(startState, {type: CLEAR_FORM_VALUES})).to.eql(initialState);
    expect(modalForm(startState, {type: CLOSE_FORM_MODAL})).to.eql(initialState);
  });
});
