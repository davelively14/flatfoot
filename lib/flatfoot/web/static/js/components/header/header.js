import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import * as ActionCreators from '../../actions/index';

import { Link } from 'react-router';
import MenuAuth from './menu_auth';
import MenuUnauth from './menu_unauth';

const mapStateToProps = function (state) {
  return {
    user: state.user,
    loggedIn: state.session.token ? true : false
  };
};

class Header extends Component {

  // Returns a menu, condition on whether or not the user is logged in
  renderMenu() {
    if (this.props.loggedIn) {
      return MenuAuth(this.props.user);
    } else {
      return MenuUnauth();
    }
  }

  render() {
    return (
      <header className="header">
        <nav role="navigation">
          <span className="pull-left"><Link to="/">Home</Link></span>
          {this.renderMenu()}
        </nav>
      </header>
    );
  }
}

export default connect(mapStateToProps, {})(Header);
