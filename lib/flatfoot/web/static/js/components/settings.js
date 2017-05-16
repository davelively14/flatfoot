import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import * as ActionCreators from '../actions/index';

const mapStateToProps = function (state) {

  // TODO uncomment dev cheat, delete hardcoded login
  return {
    user: state.user,
    // session: state.session,
    // logged_in: state.session.token ? true : false
    session: {token: 'dVlOYzlWQ2tkbEdUOGxYVFRxZkRpZz09'}
  };
};

const mapDispatchToProps = function (dispatch) {
  return bindActionCreators(ActionCreators, dispatch);
};

class Settings extends Component {

  // If not logged_in, will redirect to root
  // TODO uncomment dev cheat
  // componentWillMount() {
  //   this.props.logged_in ? null : browserHistory.push('/');
  // }

  // Load data after component mounts
  // TODO stopped: fetch user info and settings.
  componentDidMount() {
    let uri = 'http://localhost:4000/';
    const {setUser, setToken} = this.props;
    setToken(this.props.token);
    var headers = new Headers();
    headers.append('Authorization', 'Token token="' + this.props.session.token + '"');

    fetch(uri + 'api/users/11', {
      method: 'get',
      headers: headers
    }).then(
      function(response) {
        if (response.status != 200) {
          throw 'Invalid user_id';
        }

        return response.text();
      }
    ).then(
      function(text) {
        let user = JSON.parse(text).data;
        setUser(user.id, user.username, user.email);
      }
    );
  }

  render() {
    return (
      <div className="row">
        <h2>Settings</h2>
        <div className="col-sm-4">
          <h4>{this.props.user.username}</h4>
          <p>{this.props.user.email}</p>
        </div>
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Settings);