import { ADD_WARD, REMOVE_WARD, UPDATE_WARD, LOGOUT, CLEAR_DASHBOARD } from '../actions/index';

var initialState = [];

function wards(state = initialState, action) {
  let params = action.ward_params;

  switch (action.type) {
    case ADD_WARD:
      return [
        ...state,
        {
          id: action.ward_params.id,
          name: action.ward_params.name,
          relationship: action.ward_params.relationship,
          active: action.ward_params.active
        }
      ];
    case REMOVE_WARD:
      return state.filter(ward => {
        return ward.id != action.ward_id;
      });
    case UPDATE_WARD:
      return state.map(ward => {
        if (ward.id == params.id) {
          return {
            id: params.id,
            name: params.name,
            relationship: params.relationship,
            active: params.active
          };
        } else {
          return ward;
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

export default wards;
