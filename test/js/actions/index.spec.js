import * as actions from '../../../lib/flatfoot_web/static/js/actions/index';

describe('index', () => {
  describe('types', () => {
    it('should return correct constants for Super types', () => {
      expect(actions.LOGOUT).to.eq('LOGOUT');
      expect(actions.CLEAR_DASHBOARD).to.eq('CLEAR_DASHBOARD');
    });

    it('should return correct constants for User types', () => {
      expect(actions.SET_USER).to.eq('SET_USER');
    });

    it('should return correct constants for Session types', () => {
      expect(actions.SET_TOKEN).to.eq('SET_TOKEN');
      expect(actions.SET_PHOENIX_TOKEN).to.eq('SET_PHOENIX_TOKEN');
      expect(actions.SET_SOCKET).to.eq('SET_SOCKET');
      expect(actions.CLEAR_SOCKET).to.eq('CLEAR_SOCKET');
    });

    it('should return correct constants for UI types', () => {
      expect(actions.TOGGLE_USER_EDIT).to.eq('TOGGLE_USER_EDIT');
      expect(actions.TOGGLE_CHANGE_PASSWORD).to.eq('TOGGLE_CHANGE_PASSWORD');
      expect(actions.SET_DASHBOARD_TAB).to.eq('SET_DASHBOARD_TAB');
      expect(actions.SET_WARD_FOCUS).to.eq('SET_WARD_FOCUS');
      expect(actions.SET_WARD_ACCOUNT_FOCUS).to.eq('SET_WARD_ACCOUNT_FOCUS');
      expect(actions.CLEAR_WARD_FOCUS).to.eq('CLEAR_WARD_FOCUS');
      expect(actions.CLEAR_WARD_ACCOUNT_FOCUS).to.eq('CLEAR_WARD_ACCOUNT_FOCUS');
      expect(actions.OPEN_FORM_MODAL).to.eq('OPEN_FORM_MODAL');
      expect(actions.CLOSE_FORM_MODAL).to.eq('CLOSE_FORM_MODAL');
      expect(actions.OPEN_CONFIRM_MODAL).to.eq('OPEN_CONFIRM_MODAL');
      expect(actions.CLOSE_CONFIRM_MODAL).to.eq('CLOSE_CONFIRM_MODAL');
    });

    it('should return correct constants for Ward types', () => {
      expect(actions.ADD_WARD).to.eq('ADD_WARD');
      expect(actions.REMOVE_WARD).to.eq('REMOVE_WARD');
      expect(actions.UPDATE_WARD).to.eq('UPDATE_WARD');
    });

    it('should return correct constants for WardAccount types', () => {
      expect(actions.ADD_WARD_ACCOUNT).to.eq('ADD_WARD_ACCOUNT');
      expect(actions.REMOVE_WARD_ACCOUNT).to.eq('REMOVE_WARD_ACCOUNT');
      expect(actions.UPDATE_WARD_ACCOUNT).to.eq('UPDATE_WARD_ACCOUNT');
    });

    it('should return correct constants for WardResult types', () => {
      expect(actions.ADD_WARD_RESULTS).to.eq('ADD_WARD_RESULTS');
      expect(actions.CLEAR_WARD_RESULTS).to.eq('CLEAR_WARD_RESULTS');
      expect(actions.ADD_WARD_RESULT).to.eq('ADD_WARD_RESULT');
      expect(actions.REMOVE_WARD_RESULT).to.eq('REMOVE_WARD_RESULT');
      expect(actions.REMOVE_WARD_RESULTS).to.eq('REMOVE_WARD_RESULTS');
    });

    it('should return correct constants for Backend types', () => {
      expect(actions.SET_BACKENDS).to.eq('SET_BACKENDS');
    });

    it('should return correct constants for ModalForm types', () => {
      expect(actions.SET_FORM_VALUES).to.eq('SET_FORM_VALUES');
      expect(actions.CLEAR_FORM_VALUES).to.eq('CLEAR_FORM_VALUES');
      expect(actions.SET_FORM_ERRORS).to.eq('SET_FORM_ERRORS');
      expect(actions.CLEAR_FORM_ERRORS).to.eq('CLEAR_FORM_ERRORS');
      expect(actions.ADD_FORM_ERROR).to.eq('ADD_FORM_ERROR');
      expect(actions.ADD_FORM_VALUE).to.eq('ADD_FORM_VALUE');
    });
  });
});
