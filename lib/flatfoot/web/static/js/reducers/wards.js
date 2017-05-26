import { ADD_WARD, REMOVE_WARD } from '../actions/index';

var initialState = [];

function wards(state = initialState, action) {
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
        return ward != action.ward_id;
      });
    default:
      return state;
  }
}

export default wards;
