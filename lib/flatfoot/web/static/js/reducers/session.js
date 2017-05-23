import { SET_TOKEN, SET_PHOENIX_TOKEN, SET_SOCKET, CLEAR_SOCKET, LOGOUT } from '../actions/index';
import { Socket } from 'phoenix';

var initialState = {
  token: undefined,
  phoenixToken: undefined,
  socket: undefined
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
    case SET_SOCKET:
      let socket = new Socket('/socket', {
        params: {token: action.phoenixToken},
        logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data); }
      });
      return Object.assign({}, state, {
        socket: socket
      });
    case CLEAR_SOCKET:
      return Object.assign({}, state, {
        socket: undefined
      });
    case LOGOUT:
      return initialState;
    default:
      return state;
  }
}

export default session;
