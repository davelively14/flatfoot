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
    logged_in: state.session.token ? true : false
  };
};

const mapDispatchToProps = function (dispatch) {
  return bindActionCreators(ActionCreators, dispatch);
};

class Header extends Component {
  renderMenu() {
    console.log(this.props.logged_in == true);
    if (this.props.logged_in) {
      return MenuAuth();
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

export default connect(mapStateToProps, mapDispatchToProps)(Header);
