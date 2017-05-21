import { TOGGLE_USER_EDIT, TOGGLE_CHANGE_PASSWORD } from '../actions/index';


var initialState = {
  showUserEdit: false,
  showChangePassword: false
};

function ui(state = initialState, action) {
  switch (action.type) {
    case TOGGLE_USER_EDIT:
      return Object.assign({}, state, {
        showUserEdit: !state.showUserEdit,
        showChangePassword: false
      });
    case TOGGLE_CHANGE_PASSWORD:
      return Object.assign({}, state, {
        showChangePassword: !state.showChangePassword,
        showUserEdit: false
      });
    default:
      return state;
  }
}

export default ui;
