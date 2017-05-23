import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import { createStore } from 'redux';
import { Router, Route, IndexRoute, browserHistory } from 'react-router';
import { syncHistoryWithStore } from 'react-router-redux';

import flatfootApp from './reducers/index';
import App from './components/app';
import Login from './components/clients/login';
import Landing from './components/landing';
import NewUser from './components/clients/new_user';
import Profile from './components/clients/profile';
import Logout from './components/logout';
import SpadeChannel from './components/spade/spade_channel';

let store = createStore(flatfootApp, window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__());
let history = syncHistoryWithStore(browserHistory, store);

render(
  <Provider store={store}>
    <Router history={history}>
      <Route path="/" component={App}>
        <IndexRoute component={Landing} />
        <Route path="login" component={Login} />
        <Route path="new-user" component={NewUser} />
        <Route path="profile" component={Profile} />
        <Route path="logout" component={Logout} />
        <Route path="dashboard" component={SpadeChannel} />
      </Route>
    </Router>
  </Provider>,
  document.getElementById('react')
);
