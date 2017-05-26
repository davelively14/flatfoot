// Super Types
export const LOGOUT = 'LOGOUT';

// User Types
export const SET_USER = 'SET_USER';

// Sesssion Types
export const SET_TOKEN = 'SET_TOKEN';
export const SET_PHOENIX_TOKEN = 'SET_PHOENIX_TOKEN';
export const SET_SOCKET = 'SET_SOCKET';
export const CLEAR_SOCKET = 'CLEAR_SOCKET';

// UI Types
export const TOGGLE_USER_EDIT = 'TOGGLE_USER_EDIT';
export const TOGGLE_CHANGE_PASSWORD = 'TOGGLE_CHANGE_PASSWORD';

// Ward Types
export const ADD_WARD = 'ADD_WARD';
export const REMOVE_WARD = 'REMOVE_WARD';

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

export const setPhoenixToken = (phoenixToken) => {
  return {
    type: SET_PHOENIX_TOKEN,
    phoenixToken
  };
};

export const setSocket = (phoenixToken) => {
  return {
    type: SET_SOCKET,
    phoenixToken
  };
};

export const clearSocket = () => {
  return {
    type: CLEAR_SOCKET
  };
};

// UI Action Creators
export const toggleUserEdit = () => {
  return {
    type: TOGGLE_USER_EDIT
  };
};

export const toggleChangePassword = () => {
  return {
    type: TOGGLE_CHANGE_PASSWORD
  };
};

// Ward Action Creators
export const addWard = (ward_params) => {
  return {
    type: ADD_WARD,
    ward_params
  };
};

export const removeWard = (ward_id) => {
  return {
    type: REMOVE_WARD,
    ward_id
  };
};
