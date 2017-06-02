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
export const SET_WARD_FOCUS = 'SET_WARD_FOCUS';
export const SET_WARD_ACCOUNT_FOCUS = 'SET_WARD_ACCOUNT_FOCUS';
export const CLEAR_WARD_FOCUS = 'CLEAR_WARD_FOCUS';
export const CLEAR_WARD_ACCOUNT_FOCUS = 'CLEAR_WARD_ACCOUNT_FOCUS';
export const OPEN_ADD_MODAL = 'OPEN_ADD_MODAL';
export const CLOSE_ADD_MODAL = 'CLOSE_ADD_MODAL';

// Ward Types
export const ADD_WARD = 'ADD_WARD';
export const REMOVE_WARD = 'REMOVE_WARD';

// WardAccount Types
export const ADD_WARD_ACCOUNT = 'ADD_WARD_ACCOUNT';

// WardResult Types
export const ADD_WARD_RESULTS = 'ADD_WARD_RESULTS';
export const ADD_WARD_RESULT = 'ADD_WARD_RESULT';

// ModalForm Types
export const SET_FORM_VALUES = 'SET_FORM_VALUES';
export const CLEAR_FORM_VALUES = 'CLEAR_FORM_VALUES';
export const SET_FORM_ERRORS = 'SET_FORM_ERRORS';
export const CLEAR_FORM_ERRORS = 'SET_FORM_ERRORS';

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
  return {
    type: SET_DASHBOARD_TAB,
    newTab
  };
};

export const setWardFocus = (ward_id) => {
  return {
    type: SET_WARD_FOCUS,
    ward_id
  };
};

export const setWardAccountFocus = (ward_account_id) => {
  return {
    type: SET_WARD_ACCOUNT_FOCUS,
    ward_account_id
  };
};

export const clearWardFocus = () => {
  return {
    type: CLEAR_WARD_FOCUS
  };
};

export const clearWardAccountFocus = () => {
  return {
    type: CLEAR_WARD_ACCOUNT_FOCUS
  };
};

export const openAddModal = (modal_type) => {
  return {
    type: OPEN_ADD_MODAL,
    modal_type
  };
};

export const closeAddModal = () => {
  return {
    type: CLOSE_ADD_MODAL
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



// ModalForm Action Creators
export const setFormValues = (form_values) => {
  return {
    type: SET_FORM_VALUES,
    form_values
  };
};

export const clearFormValues = () => {
  return {
    type: CLEAR_FORM_VALUES
  };
};

export const setFormErrors = (form_errors) => {
  return {
    type: SET_FORM_ERRORS,
    form_errors
  };
};

export const clearFormErrors = () => {
  return {
    type: CLEAR_FORM_VALUES
  };
};
