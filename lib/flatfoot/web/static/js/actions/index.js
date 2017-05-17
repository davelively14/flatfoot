// Action Types
export const SET_USER = 'SET_USER';
export const SET_TOKEN = 'SET_TOKEN';
export const LOGOUT = 'LOGOUT';
export const SET_SETTINGS = 'SET_SETTINGS';

// Super Action Creators
export const logout = () => {
  return {
    type: LOGOUT
  };
};

// User Action Creators
export const setUser = (id, username, email) => {
  return {
    type: SET_USER,
    id,
    username,
    email
  };
};

export const setSettings = (globalThreshold) => {
  return {
    type: SET_SETTINGS,
    globalThreshold
  };
};

// Session Action Creators
export const setToken = (token) => {
  return {
    type: SET_TOKEN,
    token
  };
};
