import { combineReducers } from 'redux';
import { routerReducer } from 'react-router-redux';
import { reducer as formReducer } from 'redux-form';

import user from './user';
import session from './session';
import ui from './ui';
import wards from './wards';
import ward_accounts from './ward_accounts';

const flatfootApp = combineReducers({
  user,
  session,
  ui,
  wards,
  ward_accounts,
  routing: routerReducer,
  form: formReducer
});

export default flatfootApp;
