import { ADD_WARD } from '../actions/index';

var initialState = [];

function wards (state = initialState, action) {
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
    default:
      return state;
  }
}

export default wards;
