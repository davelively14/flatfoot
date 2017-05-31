import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../../actions/index';

const mapStateToProps = (_state, ownProps) => {
  return {
    wardAccounts: ownProps.wardAccounts
  };
};

const mapDispatchToProps = (dispatch) => {
  return bindActionCreators(ActionCreators, dispatch);
};

class WardAccountsDetail extends Component {


  renderWardAccounts() {
    return (
      <tr>
        <td colSpan="2"><i>No results</i></td>
      </tr>
    );
  }

  render() {
    return(
      <div>
        <h4>Accounts</h4>
        <table className="table table-hover">
          <thead>
            <tr>
              <th>Handle</th>
              <th>Network</th>
            </tr>
          </thead>
          <tbody>
            {this.renderWardAccounts()}
          </tbody>
        </table>
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(WardAccountsDetail);
