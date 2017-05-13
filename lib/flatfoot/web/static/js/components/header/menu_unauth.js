import React from 'react';
import { Link } from 'react-router';

const MenuUnauth = () => {
  return (
    <ol className="breadcrumb text-right">
      <li><Link to="/new-user">New User</Link></li>
      <li><Link to="/login">Login</Link></li>
    </ol>
  );
};

export default MenuUnauth;
