import {
  SET_FORM_VALUES, CLEAR_FORM_VALUES, SET_FORM_ERRORS, CLEAR_FORM_ERRORS,
  ADD_FORM_ERROR, ADD_FORM_VALUE, CLOSE_FORM_MODAL
} from '../actions/index';

var initialState = {
  formValues: undefined,
  formErrors: undefined
};

function modalForm(state = initialState, action) {
  var newAddition = {};
  var formErrors = state.formErrors;
  var formValues = state.formValues;

  switch (action.type) {
    case SET_FORM_VALUES:
      return Object.assign({}, state, {
        formValues: action.form_values
      });
    case ADD_FORM_VALUE:
      if (!action.key || !action.value) {
        return state;
      }
      newAddition[action.key] = action.value;
      formValues = Object.assign({}, formValues, newAddition);

      return Object.assign({}, state, {
        formValues: formValues
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
    case ADD_FORM_ERROR:
      if (!action.key || !action.value) {
        return state;
      }
      newAddition[action.key] = action.value;
      formErrors = Object.assign({}, formErrors, newAddition);

      return Object.assign({}, state, {
        formErrors: formErrors
      });
    case CLOSE_FORM_MODAL:
      return initialState;
    default:
      return state;
  }
}

export default modalForm;
