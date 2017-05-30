/********
  TYPES
********/

// Super Types
export const LOGOUT = 'LOGOUT';
export const CLEAR_DASHBOARD = 'CLEAR_DASHBOARD';

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
export const SET_DASHBOARD_TAB = 'SET_DASHBOARD_TAB';

// Ward Types
export const ADD_WARD = 'ADD_WARD';
export const REMOVE_WARD = 'REMOVE_WARD';

// WardAccount Types
export const ADD_WARD_ACCOUNT = 'ADD_WARD_ACCOUNT';

// WardResult Types
export const ADD_WARD_RESULTS = 'ADD_WARD_RESULTS';
export const ADD_WARD_RESULT = 'ADD_WARD_RESULT';

/******************
  ACTION CREATORS
******************/

// Super Action Creators
export const logout = () => {
  return {
    type: LOGOUT
  };
};

export const clearDashboard = () => {
  return {
    type: CLEAR_DASHBOARD
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

export const setDashboardTab = (newTab) => {
  console.log(newTab);
  return {
    type: SET_DASHBOARD_TAB,
    newTab
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

// WardAccount Action Creators
export const addWardAccount = (ward_account_params) => {
  return {
    type: ADD_WARD_ACCOUNT,
    ward_account_params
  };
};

// WardResult Action Creators
export const addWardResult = (ward_result_params) => {
  return {
    type: ADD_WARD_RESULT,
    ward_result_params
  };
};

export const addWardResults = (ward_results) => {
  return {
    type: ADD_WARD_RESULTS,
    ward_results
  };
};
