import React from 'react';
import {Link} from 'react-router';

const App = ({children}) => (
  <div className="container">
    <header className="header">
      <nav role="navigation">
        <ol className="breadcrumb text-right">
          <li className="pull-left"><Link to="/">Home</Link></li>
          <li>Blank for Now</li>
          <li><Link to="/login">Login</Link></li>
        </ol>
      </nav>
    </header>

    {children}
  </div>
);

export default App;
