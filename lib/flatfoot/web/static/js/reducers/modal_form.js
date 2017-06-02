import { SET_FORM_VALUES, CLEAR_FORM_VALUES, CLOSE_ADD_MODAL } from '../actions/index';

var initialState = {
  formValues: undefined
};

function modalForm(state = initialState, action) {
  switch (action.type) {
    case SET_FORM_VALUES:
      return Object.assign({}, state, {
        formValues: action.form_values
      });
    case CLEAR_FORM_VALUES:
      return initialState;
    case CLOSE_ADD_MODAL:
      return initialState;
    default:
      return state;
  }
}

export default modalForm;
