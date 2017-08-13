import {
  ADD_WARD_RESULT, CLEAR_WARD_RESULTS, ADD_WARD_RESULTS, REMOVE_WARD_ACCOUNT,
  LOGOUT, REMOVE_WARD_RESULT, REMOVE_WARD_RESULTS, CLEAR_DASHBOARD
} from '../actions/index';

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
          msgId: action.ward_result_params.msg_id,
          msgText: action.ward_result_params.msg_text,
          wardAccountId: action.ward_result_params.ward_account_id,
          backendId: action.ward_result_params.backend_id,
          timestamp: action.ward_result_params.timestamp
        }
      ];
    case ADD_WARD_RESULTS:
      return state.concat(
        action.ward_results.map(ward_result => {
          return {
            id: ward_result.id,
            rating: ward_result.rating,
            from: ward_result.from,
            msgId: ward_result.msg_id,
            msgText: ward_result.msg_text,
            wardAccountId: ward_result.ward_account_id,
            backendId: ward_result.backend_id,
            timestamp: ward_result.timestamp
          };
        })
      );
    case REMOVE_WARD_RESULT:
      return state.filter(wardResult => {
        return wardResult.id != action.ward_result.id;
      });
    case REMOVE_WARD_RESULTS:
      return state.filter(stateWardResult => {
        let keepResult = true;

        action.ward_results.forEach(deletedWardResult => {
          if (stateWardResult.id == deletedWardResult.id) {
            keepResult = false;
          }
        });

        return keepResult;
      });
    case REMOVE_WARD_ACCOUNT:
      return state.filter(wardResult => {
        return wardResult.wardAccountId != action.id;
      });
    case LOGOUT:
    case CLEAR_DASHBOARD:
    case CLEAR_WARD_RESULTS:
      return initialState;
    default:
      return state;
  }
}

export default wardResults;
