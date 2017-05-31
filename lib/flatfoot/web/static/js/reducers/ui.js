import { TOGGLE_USER_EDIT, TOGGLE_CHANGE_PASSWORD, SET_DASHBOARD_TAB, SET_WARD_FOCUS, SET_WARD_ACCOUNT_FOCUS, LOGOUT } from '../actions/index';


var initialState = {
  showUserEdit: false,
  showChangePassword: false,
  dashboardTab: 'Overview',
  wardFocus: undefined,
  wardAccountFocus: undefined
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
    case SET_WARD_FOCUS:
      return Object.assign({}, state, {
        dashboardTab: 'My Wards',
        wardFocus: action.ward_id
      });
    case SET_WARD_ACCOUNT_FOCUS:
      return Object.assign({}, state, {
        wardAccountFocus: action.ward_account_id
      });
    case LOGOUT:
      return initialState;
    default:
      return state;
  }
}

export default ui;
