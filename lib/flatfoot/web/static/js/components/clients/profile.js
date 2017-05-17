import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import * as ActionCreators from '../../actions/index';
import { fetchUser } from '../api';

const mapStateToProps = function (state) {

  return {
    user: state.user,
    logged_in: true,
    // TODO uncomment dev cheat, delete hardcoded session
    // session: state.session,
    // logged_in: state.session.token ? true : false
    session: {token: 'VjdjNnlXOG1GTFoxY2xqV0lLTUlIZz09'}
  };
};

const mapDispatchToProps = function (dispatch) {
  return bindActionCreators(ActionCreators, dispatch);
};

class Profile extends Component {

  // If not logged_in, will redirect to root
  // TODO if not logged_in, check cookies before redirecting
  componentWillMount() {
    this.props.logged_in ? null : browserHistory.push('/');
  }

  // Load data after component mounts
  componentDidMount() {
    fetchUser(this.props.setUser, this.props.session.token);
  }

  render() {
    return (
      <div className="row">
        <h2>Profile</h2>
        <div className="col-sm-4">
          <h4>{this.props.user.username}</h4>
          <p>{this.props.user.email}</p>
          <button className="btn btn-primary btn-sm">Edit</button>
        </div>
        <div className="col-sm-8">

        </div>
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Profile);
