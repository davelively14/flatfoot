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
export const OPEN_FORM_MODAL = 'OPEN_FORM_MODAL';
export const CLOSE_FORM_MODAL = 'CLOSE_FORM_MODAL';
export const OPEN_CONFIRM_MODAL = 'OPEN_CONFIRM_MODAL';
export const CLOSE_CONFIRM_MODAL = 'CLOSE_CONFIRM_MODAL';

// Ward Types
export const ADD_WARD = 'ADD_WARD';
export const REMOVE_WARD = 'REMOVE_WARD';
export const UPDATE_WARD = 'UPDATE_WARD';

// WardAccount Types
export const ADD_WARD_ACCOUNT = 'ADD_WARD_ACCOUNT';
export const REMOVE_WARD_ACCOUNT = 'REMOVE_WARD_ACCOUNT';
export const UPDATE_WARD_ACCOUNT = 'UPDATE_WARD_ACCOUNT';

// WardResult Types
export const ADD_WARD_RESULTS = 'ADD_WARD_RESULTS';
export const CLEAR_WARD_RESULTS = 'CLEAR_WARD_RESULTS';
export const ADD_WARD_RESULT = 'ADD_WARD_RESULT';
export const REMOVE_WARD_RESULT = 'REMOVE_WARD_RESULT';
export const REMOVE_WARD_RESULTS = 'REMOVE_WARD_RESULTS';

// Backend Types
export const SET_BACKENDS = 'SET_BACKENDS';

// ModalForm Types
export const SET_FORM_VALUES = 'SET_FORM_VALUES';
export const CLEAR_FORM_VALUES = 'CLEAR_FORM_VALUES';
export const SET_FORM_ERRORS = 'SET_FORM_ERRORS';
export const CLEAR_FORM_ERRORS = 'CLEAR_FORM_ERRORS';
export const ADD_FORM_ERROR = 'ADD_FORM_ERROR';
export const ADD_FORM_VALUE = 'ADD_FORM_VALUE';

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

export const openFormModal = (name) => {
  return {
    type: OPEN_FORM_MODAL,
    name
  };
};

export const closeFormModal = () => {
  return {
    type: CLOSE_FORM_MODAL
  };
};

export const openConfirmModal = (name) => {
  return {
    type: OPEN_CONFIRM_MODAL,
    name
  };
};

export const closeConfirmModal = () => {
  return {
    type: CLOSE_CONFIRM_MODAL
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

export const updateWard = (ward_params) => {
  return {
    type: UPDATE_WARD,
    ward_params
  };
};



// WardAccount Action Creators
export const addWardAccount = (ward_account_params) => {
  return {
    type: ADD_WARD_ACCOUNT,
    ward_account_params
  };
};

export const removeWardAccount = (ward_account_id) => {
  return {
    type: REMOVE_WARD_ACCOUNT,
    ward_account_id
  };
};

export const updateWardAccount = (ward_account_params) => {
  return {
    type: UPDATE_WARD_ACCOUNT,
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

export const clearWardResults = () => {
  return {
    type: CLEAR_WARD_RESULTS
  };
};

export const addWardResults = (ward_results) => {
  return {
    type: ADD_WARD_RESULTS,
    ward_results
  };
};

export const removeWardResult = (ward_result) => {
  return {
    type: REMOVE_WARD_RESULT,
    ward_result
  };
};

export const removeWardResults = (ward_results) => {
  return {
    type: REMOVE_WARD_RESULTS,
    ward_results
  };
};



// Backend Action Creators
export const setBackends = (backends) => {
  return {
    type: SET_BACKENDS,
    backends
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
    type: CLEAR_FORM_ERRORS
  };
};

export const addFormError = (key, value) => {
  return {
    type: ADD_FORM_ERROR,
    key,
    value
  };
};

export const addFormValue = (key, value) => {
  return {
    type: ADD_FORM_VALUE,
    key,
    value
  };
};
