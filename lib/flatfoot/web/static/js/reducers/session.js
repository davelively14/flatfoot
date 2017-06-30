import { SET_TOKEN, SET_PHOENIX_TOKEN, SET_SOCKET, CLEAR_SOCKET, LOGOUT } from '../actions/index';
import { Socket } from 'phoenix';
import Cookies from 'universal-cookie';

var initialState = {
  token: undefined,
  phoenixToken: undefined,
  socket: undefined
};

function session(state = initialState, action) {
  const cookies = new Cookies();
  let socket;

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
      socket = new Socket('/socket', {
        params: {token: action.phoenixToken},
        // logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data); }
      });
      return Object.assign({}, state, {
        socket: socket
      });
    case CLEAR_SOCKET:
      return Object.assign({}, state, {
        socket: undefined
      });
    case LOGOUT:
      cookies.remove('token');
      return initialState;
    default:
      return state;
  }
}

export default session;
