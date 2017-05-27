import { combineReducers } from 'redux';
import { routerReducer } from 'react-router-redux';
import { reducer as formReducer } from 'redux-form';

import user from './user';
import session from './session';
import ui from './ui';
import wards from './wards';
import wardAccounts from './ward_accounts';
import wardResults from './ward_results';

const flatfootApp = combineReducers({
  user,
  session,
  ui,
  wards,
  wardAccounts,
  wardResults,
  routing: routerReducer,
  form: formReducer
});

export default flatfootApp;
