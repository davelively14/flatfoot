import { ADD_WARD_ACCOUNT } from '../actions/index';

var initialState = [];

function wards(state = initialState, action) {
  switch (action.type) {
    case ADD_WARD_ACCOUNT:
      return [
        ...state,
        {
          id: action.ward_account_params.id,
          ward_id: action.ward_account_params.ward_id,
          backend_module: action.ward_account_params.backend_module,
          handle: action.ward_account_params.handle,
          network: action.ward_account_params.network
        }
      ];
    default:
      return state;
  }
}

export default wards;
