import {
  SET_FORM_VALUES, CLEAR_FORM_VALUES, SET_FORM_ERRORS, CLEAR_FORM_ERRORS, CLOSE_ADD_MODAL
} from '../actions/index';

var initialState = {
  formValues: undefined,
  formErrors: undefined
};

function modalForm(state = initialState, action) {
  switch (action.type) {
    case SET_FORM_VALUES:
      return Object.assign({}, state, {
        formValues: action.form_values
      });
    case SET_FORM_ERRORS:
      return Object.assign({}, state, {
        formErrors: action.form_errors
      });
    case CLEAR_FORM_VALUES:
      return initialState;
    case CLEAR_FORM_ERRORS:
      return Object.assign({}, state, {
        formErrors: undefined
      });
    case CLOSE_ADD_MODAL:
      return initialState;
    default:
      return state;
  }
}

export default modalForm;
