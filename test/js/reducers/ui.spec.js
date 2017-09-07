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

  it('should set wardAccountFocus with SET_WARD_ACCOUNT_FOCUS type and id', () => {
    let endState = Object.assign({}, initialState, {wardAccountFocus: 102});
    expect(ui(initialState, {type: SET_WARD_ACCOUNT_FOCUS, ward_account_id: 102})).to.eql(endState);
  });

  it('should set wardAccountFocus to undefined with SET_WARD_ACCOUNT_FOCUS type and no id', () => {
    let startState = Object.assign({}, initialState, {wardAccountFocus: 102});
    expect(startState.wardAccountFocus).to.eq(102);
    expect(ui(startState, {type: SET_WARD_ACCOUNT_FOCUS}).wardAccountFocus).to.be.undefined;
  });

  it('should clear relevant ward focus vars with CLEAR_WARD_FOCUS type', () => {
    let startState = Object.assign({}, initialState, {wardFocus: 1, wardAccountFocus: 101});
    expect(ui(startState, {type: CLEAR_WARD_FOCUS})).to.eql(initialState);
  });

  it('should clear wardAccountFocus with CLEAR_WARD_ACCOUNT_FOCUS type', () => {
    let startState = Object.assign({}, initialState, {wardAccountFocus: 101});
    expect(ui(startState, {type: CLEAR_WARD_ACCOUNT_FOCUS})).to.eql(initialState);
  });

  it('should set formModal with OPEN_FORM_MODAL and name', () => {
    let endState = Object.assign({}, initialState, {formModal: 'newUser'});
    expect(ui(initialState, {type: OPEN_FORM_MODAL, name: 'newUser'})).to.eql(endState);
  });

  it('should set formModal to undefined with OPEN_FORM_MODAL and no name', () => {
    let startState = Object.assign({}, initialState, {formModal: 'newUser'});
    expect(startState.formModal).to.eq('newUser');
    expect(ui(startState, {type: OPEN_FORM_MODAL}).formModal).to.be.undefined;
  });

  it('should remove wardFocus and wardAccountFocus on REMOVE_WARD type and matching ward id', () => {
    let startState = Object.assign({}, initialState, {wardFocus: 1, wardAccountFocus: 101});
    expect(ui(startState, {type: REMOVE_WARD, id: 1})).to.eql(initialState);
  });

  it('should maintain wardFocus and wardAccountFocus on REMOVE_WARD type and non-matching ward id', () => {
    let startState = Object.assign({}, initialState, {wardFocus: 1, wardAccountFocus: 101});
    expect(ui(startState, {type: REMOVE_WARD, id: 12})).to.eql(startState);
  });

  it('should set formModal to undefined with CLOSE_FORM_MODAL type', () => {
    let startState = Object.assign({}, initialState, {formModal: 'newUser'});
    expect(startState.formModal).to.eq('newUser');
    expect(ui(startState, {type: CLOSE_FORM_MODAL}).formModal).to.be.undefined;
  });

  it('should set confirmModal to passed name with OPEN_CONFIRM_MODAL type', () => {
    let endState = Object.assign({}, initialState, {confirmModal: 'yesorno'});
    expect(ui(initialState, {type: OPEN_CONFIRM_MODAL, name: 'yesorno'})).to.eql(endState);
  });

  it('should set confirmModal to undefined if not passed name with OPEN_CONFIRM_MODAL type', () => {
    let startState = Object.assign({}, initialState, {confirmModal: 'yesorno'});
    expect(startState.confirmModal).to.eq('yesorno');
    expect(ui(startState, {type: OPEN_CONFIRM_MODAL}).confirmModal).to.be.undefined;
  });

  it('should set confirmModal to undefined with CLOSE_CONFIRM_MODAL type', () => {
    let startState = Object.assign({}, initialState, {confirmModal: 'yesorno'});
    expect(startState.confirmModal).to.eq('yesorno');
    expect(ui(startState, {type: CLOSE_CONFIRM_MODAL}).confirmModal).to.be.undefined;
  });

  it('should reset state to initialState with LOGOUT type', () => {
    let startState = {
      showUserEdit: true,
      showChangePassword: false,
      dashboardTab: 'My Wards',
      wardFocus: 1,
      wardAccountFocus: 12,
      formModal: undefined,
      confirmModal: undefined
    };
    expect(ui(startState, {type: LOGOUT})).to.eql(initialState);
  });
});
