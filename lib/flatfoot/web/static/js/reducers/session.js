import { SET_TOKEN, LOGOUT } from '../actions/index';

var initialState = {
  token: undefined
};

function session(state = initialState, action) {
  switch (action.type) {
    case SET_TOKEN:
      return {
        token: action.token
      };
    case LOGOUT:
      return initialState;
    default:
      return state;
  }
}

export default session;
