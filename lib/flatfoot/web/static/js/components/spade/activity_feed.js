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
  return bindActionCreators(ActionCreators, dispatch);
};

class ActivityFeed extends Component {
  renderResult(_result, _key) {
    return (
      <div className="panel panel-info">
        <div className="panel-heading">
          <h4>Ward Name (@handle) <span className="pull-right badge">35</span></h4>
          <span className="text-right">Twitter</span>
        </div>
        <table className="table">
          <tbody>
            <tr>
              <td className="text-center"><strong>From</strong></td>
              <td>@some_handle</td>
            </tr>
            <tr>
              <td className="text-center"><strong>Body</strong></td>
              <td>Duis ultrices vestibulum lacus non luctus. Praesent aliquet, justo ut accumsan bibendum, sem erat sagittis nunc, a vulputate diam ulla nisi.</td>
            </tr>
          </tbody>
        </table>
        <div className="panel-footer">
          DTG
        </div>
      </div>
    );
  }

  // renderResults() {
  //
  // }

  render() {
    return (
      <div>
        <h3>Activity Feed</h3>
        {this.renderResult(1, 2)}
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(ActivityFeed);
