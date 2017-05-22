import { SET_TOKEN, SET_PHOENIX_TOKEN, LOGOUT } from '../actions/index';

var initialState = {
  token: undefined,
  phoenixToken: undefined
};

function session(state = initialState, action) {
  switch (action.type) {
    case SET_TOKEN:
      return Object.assign({}, state, {
        token: action.token
      });
    case SET_PHOENIX_TOKEN:
      return Object.assign({}, state, {
        phoenixToken: action.phoenixToken
      });
    case LOGOUT:
      return initialState;
    default:
      return state;
  }
}

export default session;
