import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import * as ActionCreators from '../../actions/index';

const mapStateToProps = function (state) {
  let tableItems = state.wardAccounts.map(function(wardAccount) {
    let ward = state.wards.filter(ward => {
      return ward.id == wardAccount.wardId;
    })[0];

    return Object.assign({}, wardAccount, {
      name: ward.name
    });
  });

  return {
    tableItems: tableItems
  };
};

const mapDispatchToProps = function (dispatch) {
  return bindActionCreators(ActionCreators, dispatch);
};

class WardList extends Component {
  renderResult(item, key) {
    return (
      <tr key={key}>
        <td>{item.name}</td>
        <td>{item.network}</td>
        <td>{item.handle}</td>
      </tr>
    );
  }

  renderResults() {
    if (this.props.tableItems.length != 0) {
      return this.props.tableItems.map(this.renderResult);
    } else {
      return (
        <tr>
          <td><i>No results</i></td>
        </tr>
      );
    }
  }

  render() {
    return(
      <div>
        <h3>Monitoring Accounts</h3>
        <table className="table table-hover">
          <thead>
            <tr>
              <th>Name</th>
              <th>Network</th>
              <th>Handle</th>
            </tr>
          </thead>
          <tbody>
            {this.renderResults()}
          </tbody>
        </table>
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(WardList);
