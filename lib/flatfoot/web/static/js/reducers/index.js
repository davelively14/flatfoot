import { combineReducers } from 'redux';
import { routerReducer } from 'react-router-redux';
import { reducer as formReducer } from 'redux-form';
import user from './user';
import session from './session';

const flatfootApp = combineReducers({
  user,
  session,
  routing: routerReducer,
  form: formReducer
});

export default flatfootApp;
