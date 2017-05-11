import {combineReducers} from 'redux';
import {routerReducer} from 'react-router-redux';
import user from './user';

const flatfootApp = combineReducers({
  user,
  routing: routerReducer
});

export default flatfootApp;
