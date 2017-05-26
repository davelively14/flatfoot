import { ADD_WARD, REMOVE_WARD } from '../actions/index';

var initialState = [];

function wards(state = initialState, action) {
  switch (action.type) {
    case ADD_WARD:
      return [
        ...state,
        {
          name: action.name,
          relationship: action.relationship,
          active: action.active
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
