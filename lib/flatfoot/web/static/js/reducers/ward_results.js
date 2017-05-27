import { ADD_WARD_RESULT, LOGOUT, CLEAR_DASHBOARD } from '../actions/index';

var initialState = [];

function wardResults(state = initialState, action) {
  switch (action.type) {
    case ADD_WARD_RESULT:
      return [
        ...state,
        {
          id: action.ward_result_params.id,
          rating: action.ward_result_params.rating,
          from: action.ward_result_params.from,
          msg_id: action.ward_result_params.msg_id,
          msg_text: action.ward_result_params.msg_text,
          ward_account_id: action.ward_result_params.ward_account_id,
          backend_id: action.ward_result_params.backend_id
        }
      ];
    case LOGOUT:
      return initialState;
    case CLEAR_DASHBOARD:
      return initialState;
    default:
      return state;
  }
}

export default wardResults;
