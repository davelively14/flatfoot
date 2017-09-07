import ui from '../../../lib/flatfoot_web/static/js/reducers/ui';

const initialState = {
  showUserEdit: false,
  showChangePassword: false,
  dashboardTab: 'Overview',
  wardFocus: undefined,
  wardAccountFocus: undefined,
  formModal: undefined,
  confirmModal: undefined
};

const TOGGLE_USER_EDIT = 'TOGGLE_USER_EDIT';
const TOGGLE_CHANGE_PASSWORD = 'TOGGLE_CHANGE_PASSWORD';
const SET_DASHBOARD_TAB = 'SET_DASHBOARD_TAB';
const SET_WARD_FOCUS = 'SET_WARD_FOCUS';
const SET_WARD_ACCOUNT_FOCUS = 'SET_WARD_ACCOUNT_FOCUS';
const CLEAR_WARD_FOCUS = 'CLEAR_WARD_FOCUS';
const CLEAR_WARD_ACCOUNT_FOCUS = 'CLEAR_WARD_ACCOUNT_FOCUS';
const OPEN_FORM_MODAL = 'OPEN_FORM_MODAL';
const CLOSE_FORM_MODAL = 'CLOSE_FORM_MODAL';
const OPEN_CONFIRM_MODAL = 'OPEN_CONFIRM_MODAL';
const CLOSE_CONFIRM_MODAL = 'CLOSE_CONFIRM_MODAL';
const REMOVE_WARD = 'REMOVE_WARD';
const LOGOUT = 'LOGOUT';

var diffState = Object.assign({}, initialState, { showUserEdit: true });

describe('ui', () => {
  it('should set default state to initialState', () => {
    expect(ui(undefined, {})).to.eql(initialState);
  });

  it('should return current state by default', () => {
    expect(ui(undefined, {type: 'NO_LEGIT_TYPE'})).to.eql(initialState);
    expect(ui(diffState, {type: 'NO_LEGIT_TYPE'})).to.eql(diffState);
  });

  it('should toggle showUserEdit with TOGGLE_USER_EDIT type', () => {
    let showFalse = Object.assign({}, initialState, {showChangePassword: true});
    let showTrue = Object.assign({}, initialState, {showUserEdit: true});
    expect(ui(showFalse, {type: TOGGLE_USER_EDIT})).to.eql(showTrue);
    expect(ui(showTrue, {type: TOGGLE_USER_EDIT})).to.eql(initialState);
  });

  it('should toggle showChangePassword and set showUserEdit to false with TOGGLE_CHANGE_PASSWORD type', () => {
    let showFalse = Object.assign({}, initialState, {showUserEdit: true});
    let showTrue = Object.assign({}, initialState, {showChangePassword: true});
    expect(ui(showFalse, {type: TOGGLE_CHANGE_PASSWORD})).to.eql(showTrue);
    expect(ui(showTrue, {type: TOGGLE_CHANGE_PASSWORD})).to.eql(initialState);
  });

  it('should reset wardFocus and wardAccountFocus if SET_DASHBOARD_TAB type when newTab is Overview', () => {
    let startState = Object.assign({}, initialState, {wardFocus: 12, wardAccountFocus: 13, dashboardTab: 'Overview'});
    let endState = Object.assign({}, startState, {wardFocus: undefined, wardAccountFocus: undefined, dashboardTab: 'Overview'});
    expect(ui(startState, {type: SET_DASHBOARD_TAB, newTab: 'Overview'})).to.eql(endState);
  });

  it('should set new tab with SET_DASHBOARD_TAB type and a newTab', () => {
    let startState = Object.assign({}, initialState, {wardFocus: 12, wardAccountFocus: 13, dashboardTab: 'Overview'});
    let endState = Object.assign({}, startState, {dashboardTab: 'Basics'});
    expect(ui(startState, {type: SET_DASHBOARD_TAB, newTab: 'Basics'})).to.eql(endState);
  });

  it('should change tab to My Wards, set wardFocus, and clear WardAccountFocus on SET_WARD_FOCUS type', () => {
    let startState = Object.assign({}, initialState, {dashboardTab: 'Overview', wardFocus: undefined, wardAccountFocus: 13});
    let endState = Object.assign({}, startState, {dashboardTab: 'My Wards', wardFocus: 1, wardAccountFocus: undefined});
    expect(ui(startState, {type: SET_WARD_FOCUS, ward_id: 1})).to.eql(endState);
  });
});
