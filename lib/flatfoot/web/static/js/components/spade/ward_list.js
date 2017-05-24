import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import * as ActionCreators from '../../actions/index';

const mapStateToProps = function (_state) {
  return {

  };
};

const mapDispatchToProps = function (dispatch) {
  bindActionCreators(ActionCreators, dispatch);
};

class WardList extends Component {
  render() {
    return(
      <div>
        <h1>Wards List</h1>
        <ul>
          <li>Temp</li>
          <li>Temp</li>
          <li>Temp</li>
        </ul>
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(WardList);
