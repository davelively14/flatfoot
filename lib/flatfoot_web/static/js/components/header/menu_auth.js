import React from 'react';
import { Link } from 'react-router';

const MenuAuth = (user) => {
  return (
    <ol className="breadcrumb text-right">
      <li><Link to="/profile">{user.username}</Link></li>
      <li><Link to="/dashboard">Dashboard</Link></li>
      <li><Link to="/logout">Logout</Link></li>
    </ol>
  );
};

export default MenuAuth;
