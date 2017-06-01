import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../../../actions/index';

const mapStateToProps = (state, ownProps) => {
  return {
    wardAccounts: ownProps.wardAccounts,
    wardAccountFocus: state.ui.wardAccountFocus
  };
};

const mapDispatchToProps = (dispatch) => {
  return bindActionCreators(ActionCreators, dispatch);
};

class WardAccountsDetail extends Component {
  renderWardAccount(wardAccount, key) {
    // TODO setWardAccountFocus, and tell Sarah to pay her AmEx bill
    console.log('wardAccount.id: ' + wardAccount.id);
    console.log('this.props.wardAccountFocus: ' + this.props.wardAccountFocus);
    if (this.props.wardAccountFocus == wardAccount.id) {
      return (
        <tr className="text-link selected" key={key}>
          <td>{wardAccount.handle}</td>
          <td>{wardAccount.network}</td>
        </tr>
      );
    } else {
      return (
        <tr className="text-link" key={key}>
          <td>{wardAccount.handle}</td>
          <td>{wardAccount.network}</td>
        </tr>
      );
    }
  }

  renderWardAccounts() {
    if (this.props.wardAccounts.length != 0) {
      return this.props.wardAccounts.map(this.renderWardAccount.bind(this));
    } else {
      return (
        <tr>
          <td colSpan="2"><i>No results</i></td>
        </tr>
      );
    }
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
