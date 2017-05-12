import { SET_USER } from '../actions/index';

var initialState = {
  email: undefined,
  username: undefined
};

function user(state = initialState, action) {
  switch (action.type) {
    case SET_USER:
      return {
        email: action.email,
        username: action.username
      };
    default:
      return state;
  }
}

export default user;
