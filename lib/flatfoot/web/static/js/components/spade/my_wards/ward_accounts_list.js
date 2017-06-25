import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../../../actions/index';

import AddButton from '../shared/add_button';
import FormModal from '../shared/form_modal';

const mapStateToProps = (state, ownProps) => {
  return {
    wardAccounts: ownProps.wardAccounts,
    wardAccountFocus: state.ui.wardAccountFocus,
    backends: state.backends,
    wardId: state.ui.wardFocus,
    formModal: state.ui.formModal,
    wardAccountId: state.ui.wardAccountFocus,
    channel: state.session.socket ? state.session.socket.channels[0] : undefined
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

  setBackendsSelect(backends) {
    return backends.map(backend => {
      return {
        text: backend.name,
        value: backend.id
      };
    });
  }

  submitForm(values) {
    this.props.clearFormErrors();
    let valid = true;

    if (!values || !values.handle) {
      this.props.addFormError('handle', 'Cannot be blank');
      valid = false;
    }

    if (valid) {
      switch (this.props.formModal) {
        case 'addWardAccount':
          this.props.channel.push('create_ward_account', {ward_account_params: {
            handle: values.handle,
            ward_id: this.props.wardId,
            backend_id: values.backend_id
          }});
          break;
        case 'editWardAccount':
          this.props.channel.push('update_ward_account', {id: this.props.wardAccountId, updated_params: {
            handle: values.handle,
            backend_id: values.backend_id
          }});
          break;
        default:
          console.log('No valid form open, nothing saved');
      }
      this.props.closeFormModal();
    }
  }

  render() {
    return(
      <div>
        <FormModal
          name="addWardAccount"
          onSubmit={this.submitForm.bind(this)}
          inputs={[
            {type: 'text', name: 'handle', text: 'Handle', focus: true},
            {type: 'select', name: 'backend_id', text: 'Network', selectObjects: this.setBackendsSelect(this.props.backends)}
          ]}
          title="Add Ward Account"
          instructions="Enter a handle, or username, for one of your ward's social media accounts and select the social media network from the dropdown."
        />
        <FormModal
          name="editWardAccount"
          onSubmit={this.submitForm.bind(this)}
          inputs={[
            {type: 'text', name: 'handle', text: 'Handle', focus: true},
            {type: 'select', name: 'backend_id', text: 'Network', selectObjects: this.setBackendsSelect(this.props.backends)}
          ]}
          title="Edit Ward Account"
          instructions="Enter a handle, or username, for one of your ward's social media accounts and select the social media network from the dropdown."
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
        <AddButton
          name="addWardAccount"
          btnText="Add Ward Account..."
          specialClass="btn btn-primary btn-xs btn-block"
        />
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(WardAccountsList);
