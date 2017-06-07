import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../../../actions/index';

import AddButton from '../shared/add_button';
import EditButton from '../shared/edit_button';
import FormModal from '../shared/form_modal';

const mapStateToProps = (state, ownProps) => {
  return {
    wardAccounts: ownProps.wardAccounts,
    wardAccountFocus: state.ui.wardAccountFocus
  };
};

const mapDispatchToProps = (dispatch) => {
  return bindActionCreators(ActionCreators, dispatch);
};

class WardAccountsList extends Component {
  renderWardAccount(wardAccount, key) {
    if (this.props.wardAccountFocus == wardAccount.id) {
      return (
        <tr className="text-link selected" key={key} onClick={() => this.props.clearWardAccountFocus()} >
          <td>{wardAccount.handle}</td>
          <td>{wardAccount.network}</td>
        </tr>
      );
    } else {
      return (
        <tr className="text-link" key={key} onClick={() => this.props.setWardAccountFocus(wardAccount.id)}>
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

  submitForm(values) {
    console.log(values);
  }

  render() {
    return(
      <div>
        <FormModal
          name="addWardAccount"
          onSubmit={this.submitForm.bind(this)}
          inputs={[
            {type: 'text', name: 'handle', text: 'Handle', focus: true}
          ]}
        />
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

export default connect(mapStateToProps, mapDispatchToProps)(WardAccountsList);
