import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import * as ActionCreators from '../../actions/index';

import Overview from './overview/overview';
import MyWards from './my_wards/my_wards';

const mapStateToProps = function (state) {
  return {
    session: state.session,
    user: state.user,
    dashboardTab: state.ui.dashboardTab,
    loggedIn: state.session.token ? true : false
  };
};

const mapDispatchToProps = function (dispatch) {
  return bindActionCreators(ActionCreators, dispatch);
};

class SpadeChannel extends React.Component {
  joinAndSetListeners(channel) {

    channel.on('user_ward_results', (resp) => {
      this.props.addWardResults(resp.ward_results);
    });

    channel.on('user_data', (resp) => {
      this.props.clearDashboard();
      resp.wards.forEach(ward => {
        this.props.addWard(ward);
        ward.ward_accounts.forEach(ward_account => {
          this.props.addWardAccount(ward_account);
        });
      });
    });

    channel.on('backends_list', (resp) => {
      this.props.setBackends(resp.backends);
    });

    channel.on('new_ward', (resp) => {
      this.props.addWard(resp);
    });

    channel.on('deleted_ward', (_resp) => {
      channel.push('get_user', {});
    });

    channel.on('updated_ward', (resp) => {
      this.props.updateWard(resp);
    });

    channel.on('new_ward_account', (resp) => {
      this.props.addWardAccount(resp);
    });

    channel.on('deleted_ward_account', (resp) => {
      this.props.removeWardAccount(resp.id);
    });

    channel.on('updated_ward_account', (resp) => {
      this.props.updateWardAccount(resp);
    });

    channel.on('new_ward_results', (_resp) => {
      this.props.clearWardResults();
      channel.push('get_ward_results_for_user', {
        token: this.props.session.token
      });
    });

    channel.on('cleared_ward_result', (resp) => {
      this.props.removeWardResult(resp);
    });

    channel.on('cleared_ward_results', (resp) => {
      this.props.removeWardResults(resp.ward_results);
    });

    channel.join()
      .receive('ok', resp => {
        this.props.clearDashboard();

        let wards = resp.wards;

        wards.forEach(ward => {
          this.props.addWard(ward);
          ward.ward_accounts.forEach(ward_account => {
            this.props.addWardAccount(ward_account);
          });
        });

        channel.push('get_ward_results_for_user', {
          token: this.props.session.token
        });

        if (this.props.backends != []) {
          channel.push('fetch_backends', {});
        }
      })
      .receive('error', resp => {
        console.log('Failed to join spade channel', resp);
      });
  }

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

      this.joinAndSetListeners(socketChannel);
    }
  }

  componentWillUnmount() {
    if (this.props.loggedIn) {
      this.props.clearSocket();
      this.props.session.socket.disconnect();
    }
  }

  // Renders the active tab and displays the tab name.
  renderActiveTab(tabName) {
    return (
      <li role="presentation" className="active"><a>{tabName}</a></li>
    );
  }

  // Renders an inactive tab with an event listener that sets the dashboard tab
  // to the new tab name via the setDashboardTab action.
  renderInactiveTab(tabName) {
    return (
      <li role="presentation"><a className="text-link" onClick={() => this.props.setDashboardTab(tabName)}>{tabName}</a></li>
    );
  }

  // If the passed tab matches the store's current ui.dashboardTab, it will
  // render it as an active tab. Otherwise, it will render it as a clickable
  // inactive tab.
  renderTab(tab) {
    if (tab == this.props.dashboardTab) {
      return this.renderActiveTab(tab);
    } else {
      return this.renderInactiveTab(tab);
    }
  }

  render() {
    return (
      <div className="row">
        <ul className="nav nav-tabs">
          {this.renderTab('Overview')}
          {this.renderTab('My Wards')}
        </ul>
        {this.props.dashboardTab == 'Overview' &&
          <Overview />
        }
        {this.props.dashboardTab == 'My Wards' &&
          <MyWards />
        }
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(SpadeChannel);
