import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import * as ActionCreators from '../../actions/index';

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
    let uri = 'http://localhost:4000/';
    const {setUser} = this.props;

    fetch(uri + 'api/users/token?token=' + this.props.session.token, {
      method: 'get'
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
