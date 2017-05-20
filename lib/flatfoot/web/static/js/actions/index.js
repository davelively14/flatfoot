// Action Types
export const SET_USER = 'SET_USER';
export const SET_TOKEN = 'SET_TOKEN';
export const LOGOUT = 'LOGOUT';

export const TOGGLE_USER_EDIT = 'TOGGLE_USER_EDIT';

// Super Action Creators
export const logout = () => {
  return {
    type: LOGOUT
  };
};

// User Action Creators
export const setUser = (id, username, email, globalThreshold = 0) => {
  return {
    type: SET_USER,
    id,
    username,
    email,
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

// UI Action Creators
export const toggleUserEdit = () => {
  return {
    type: TOGGLE_USER_EDIT
  };
};
