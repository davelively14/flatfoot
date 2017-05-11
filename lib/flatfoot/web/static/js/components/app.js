import React from 'react';
import {Link} from 'react-router';

const App = ({children}) => (
  <div>
    <h1>Hello World</h1>
    <h3>Welcome to React</h3>
    <Link to="/login">Login</Link>
    {children}
  </div>
);

export default App;
