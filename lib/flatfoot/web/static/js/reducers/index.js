import { combineReducers } from 'redux';
import { routerReducer } from 'react-router-redux';
import { reducer as formReducer } from 'redux-form';
import user from './user';
import session from './session';
import ui from './ui';
import wards from './wards';

const flatfootApp = combineReducers({
  user,
  session,
  ui,
  wards,
  routing: routerReducer,
  form: formReducer
});

export default flatfootApp;
