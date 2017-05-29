import { TOGGLE_USER_EDIT, TOGGLE_CHANGE_PASSWORD, SET_DASHBOARD_TAB, LOGOUT } from '../actions/index';


var initialState = {
  showUserEdit: false,
  showChangePassword: false,
  dashboardTab: 'overview'
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
    case SET_DASHBOARD_TAB:
      return Object.assign({}, state, {
        dashboardTab: action.newTab
      });
    case LOGOUT:
      return initialState;
    default:
      return state;
  }
}

export default ui;
