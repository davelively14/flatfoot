import { SET_USER, LOGOUT } from '../actions/index';

var initialState = {
  email: undefined,
  username: undefined,
  globalThreshold: 0
};

function user(state = initialState, action) {
  switch (action.type) {
    case SET_USER:
      return {
        email: action.email,
        username: action.username,
        globalThreshold: action.globalThreshold
      };
    case LOGOUT:
      return initialState;
    default:
      return state;
  }
}

export default user;
