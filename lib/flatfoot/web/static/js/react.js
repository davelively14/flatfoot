import React from 'react';
import {render} from 'react-dom';
import {Provider} from 'react-redux';
import {createStore} from 'redux';
import flatfootApp from './reducers/index';
import App from './components/app';

let store = createStore(flatfootApp);

render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('react')
);
