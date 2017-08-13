import { ADD_WARD_ACCOUNT, REMOVE_WARD_ACCOUNT, UPDATE_WARD_ACCOUNT, LOGOUT, CLEAR_DASHBOARD } from '../actions/index';

var initialState = [];

function wardAccounts(state = initialState, action) {
  // let params = action.ward_account_params;

  switch (action.type) {
    case ADD_WARD_ACCOUNT:
      return [
        ...state,
        {
          id: action.ward_account_params.id,
          wardId: action.ward_account_params.ward_id,
          backend_module: action.ward_account_params.backend_module,
          handle: action.ward_account_params.handle,
          network: action.ward_account_params.network
        }
      ];
    case REMOVE_WARD_ACCOUNT:
      return state.filter(wardAccount => {
        return wardAccount.id != action.ward_account_id;
      });
    case UPDATE_WARD_ACCOUNT:
      return state.map(wardAccount => {
        if (wardAccount.id == action.ward_account_params.id) {
          return {
            id: action.ward_account_params.id,
            wardId: action.ward_account_params.ward_id,
            backend_module: action.ward_account_params.backend_module,
            handle: action.ward_account_params.handle,
            network: action.ward_account_params.network
          };
        } else {
          return wardAccount;
        }
      });
    case LOGOUT:
      return initialState;
    case CLEAR_DASHBOARD:
      return initialState;
    default:
      return state;
  }
}

export default wardAccounts;
