import { SET_SETTINGS } from '../actions/index';

var initialState = {
  globalThreshold: undefined
};

function settings(state = initialState, action) {
  switch (action) {
    case SET_SETTINGS:
      return {
        globalThreshold: action.globalThreshold
      };
    default:
      return state;
  }
}

export default settings;
