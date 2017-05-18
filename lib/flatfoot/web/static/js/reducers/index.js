import { combineReducers } from 'redux';
import { routerReducer } from 'react-router-redux';
import { reducer as formReducer } from 'redux-form';
import user from './user';
import session from './session';
import settings from './settings';
import ui from './ui';

const flatfootApp = combineReducers({
  user,
  session,
  settings,
  ui,
  routing: routerReducer,
  form: formReducer
});

export default flatfootApp;
