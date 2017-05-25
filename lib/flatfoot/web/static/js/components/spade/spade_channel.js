import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import * as ActionCreators from '../../actions/index';

import WardList from './ward_list';
import ActivityFeed from './activity_feed';

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
    if (!this.props.session.socket && this.props.session.phoenixToken != nextProps.session.phoenixToken) {
      this.props.setSocket(nextProps.session.phoenixToken);
    }

    if (this.props.session.socket != nextProps.session.socket) {
      let socket = nextProps.session.socket;
      socket.connect();

    }

    if ((this.props.user.id || nextProps.user.id) && (this.props.session.socket || nextProps.session.socket)) {
      let user = nextProps.user.id ? nextProps.user : this.props.user;
      let socket = this.props.session.socket || nextProps.session.socket;
      let socketChannel = socket.channel('spade:' + user.id);

      socketChannel.join()
        .receive('ok', resp => {
          console.log(resp);
        })
        .receive('error', resp => {
          console.log('Failed to join spade channel', resp);
        });
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
          <WardList />
          <hr />
          <ActivityFeed />
        </div>
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(SpadeChannel);
