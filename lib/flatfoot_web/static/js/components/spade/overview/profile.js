import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../../../actions/index';

const mapStateToProps = function(state) {
  return {
    user: state.user
  };
};

const mapDispatchToProps = function(dispatch) {
  return bindActionCreators(ActionCreators, dispatch);
};

class Profile extends Component {
  render() {
    return (
      <div>
        <h4>{this.props.user.username}</h4>
        <p>{this.props.user.email}</p>
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Profile);
