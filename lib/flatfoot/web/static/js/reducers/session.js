import { SET_TOKEN } from '../actions/index';

var initialState = {
  token: undefined
};

function session(state = initialState, action) {
  switch (action.type) {
    case SET_TOKEN:
      return {
        token: action.token
      };
    default:
      return state;
  }
}

export default session;
