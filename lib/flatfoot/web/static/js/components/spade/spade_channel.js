import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import * as ActionCreators from '../../actions/index';

const mapStateToProps = function (state) {
  return {
    session: state.session,
    user: state.user,
    loggedIn: state.session.token ? true : false
  };
};

const mapDispatchToProps = function (dispatch) {
  return bindActionCreators(ActionCreators, dispatch);
};

class SpadeChannel extends Component {
  componentWillMount() {
    if (!this.props.loggedIn) {
      this.props.loggedIn ? null : browserHistory.push('/');
    } else {
      if (!this.props.session.socket && this.props.session.phoenixToken) {
        this.props.setSocket(this.props.session.phoenixToken);
      }
    }
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.session.socket && !this.props.session.phoenixToken && nextProps.session.phoenixToken) {
      this.props.setSocket(nextProps.session.phoenixToken);
    }

    if (!this.props.session.socket && nextProps.session.socket) {
      nextProps.session.socket.connect();
    }
  }

  componentWillUnmount() {
    if (this.props.loggedIn) {
      this.props.clearSocket();
      this.props.session.socket.disconnect();
    }
  }

  render() {
    return (
      <div className="row">
        <h2>Profile</h2>
        <div className="col-sm-4">
          <h4>{this.props.user.username}</h4>
          <p>{this.props.user.email}</p>
        </div>
        <div className="col-sm-8">
          <div>
            <h1>Wards List</h1>
            <ul>
              <li>Temp</li>
              <li>Temp</li>
              <li>Temp</li>
            </ul>
          </div>
          <hr />
          <div>
            <h1>News Feed</h1>
            <ul>
              <li>Temp</li>
              <li>Temp</li>
              <li>Temp</li>
            </ul>
          </div>

        </div>
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(SpadeChannel);
