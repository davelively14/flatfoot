// Action Types
export const SET_USER = 'SET_USER';
export const SET_TOKEN = 'SET_TOKEN';
export const LOGOUT = 'LOGOUT';

// Super Action Creators
export const logout = () => {
  return {
    type: LOGOUT
  };
};

// User Action Creators
export const setUser = (username, email) => {
  return {
    type: SET_USER,
    username,
    email
  };
};

// Session Action Creators
export const setToken = (token) => {
  return {
    type: SET_TOKEN,
    token
  };
};
