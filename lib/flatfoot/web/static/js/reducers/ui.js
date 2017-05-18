import { TOGGLE_USER_EDIT } from '../actions/index';

var initialState = {
  showUserEdit: false
};

function ui(state = initialState, action) {
  switch (action.type) {
    case TOGGLE_USER_EDIT:
      return Object.assign({}, state, {
        showUserEdit: !state.showUserEdit
      });
    default:
      return state;
  }
}

export default ui;
