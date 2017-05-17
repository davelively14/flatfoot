import { combineReducers } from 'redux';
import { routerReducer } from 'react-router-redux';
import { reducer as formReducer } from 'redux-form';
import user from './user';
import session from './session';
import settings from './settings';

const flatfootApp = combineReducers({
  user,
  session,
  settings,
  routing: routerReducer,
  form: formReducer
});

export default flatfootApp;
