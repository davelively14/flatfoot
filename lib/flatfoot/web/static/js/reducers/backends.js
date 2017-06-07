import { SET_BACKENDS, LOGOUT } from '../actions/index';

var initialState = [];

function backends(state = initialState, action) {
  switch (action.type) {
    case SET_BACKENDS:
      return action.backends;
    case LOGOUT:
      return initialState;
    default:
      return state;
  }
}

export default backends;
