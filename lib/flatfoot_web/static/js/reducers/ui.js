import {
  TOGGLE_USER_EDIT, TOGGLE_CHANGE_PASSWORD, SET_DASHBOARD_TAB, SET_WARD_FOCUS,
  SET_WARD_ACCOUNT_FOCUS, CLEAR_WARD_FOCUS, CLEAR_WARD_ACCOUNT_FOCUS,
  OPEN_FORM_MODAL, CLOSE_FORM_MODAL, OPEN_CONFIRM_MODAL, CLOSE_CONFIRM_MODAL,
  REMOVE_WARD, LOGOUT
} from '../actions/index';


var initialState = {
  showUserEdit: false,
  showChangePassword: false,
  dashboardTab: 'Overview',
  wardFocus: undefined,
  wardAccountFocus: undefined,
  formModal: undefined,
  confirmModal: undefined
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
      if (action.newTab == 'Overview') {
        return Object.assign({}, state, {
          wardFocus: undefined,
          wardAccountFocus: undefined,
          dashboardTab: action.newTab
        });
      } else {
        return Object.assign({}, state, {
          dashboardTab: action.newTab
        });
      }
    case SET_WARD_FOCUS:
      return Object.assign({}, state, {
        dashboardTab: 'My Wards',
        wardFocus: action.ward_id,
        wardAccountFocus: undefined
      });
    case SET_WARD_ACCOUNT_FOCUS:
      return Object.assign({}, state, {
        wardAccountFocus: action.ward_account_id
      });
    case CLEAR_WARD_FOCUS:
      return Object.assign({}, state, {
        wardFocus: undefined,
        wardAccountFocus: undefined
      });
    case CLEAR_WARD_ACCOUNT_FOCUS:
      return Object.assign({}, state, {
        wardAccountFocus: undefined
      });
    case OPEN_FORM_MODAL:
      return Object.assign({}, state, {
        formModal: action.name
      });
    case REMOVE_WARD:
      if (state.wardFocus == action.id) {
        return Object.assign({}, state, {
          wardFocus: undefined,
          wardAccountFocus: undefined
        });
      } else {
        return state;
      }
    case CLOSE_FORM_MODAL:
      return Object.assign({}, state, {
        formModal: undefined
      });
    case OPEN_CONFIRM_MODAL:
      return Object.assign({}, state, {
        confirmModal: action.name
      });
    case CLOSE_CONFIRM_MODAL:
      return Object.assign({}, state, {
        confirmModal: undefined
      });
    case LOGOUT:
      return initialState;
    default:
      return state;
  }
}

export default ui;
