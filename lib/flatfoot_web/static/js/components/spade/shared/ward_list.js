import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../../../actions/index';

import AddButton from './add_button';
import EditButton from './edit_button';
import FormModal from './form_modal';
import ConfirmModal from './confirm_modal';

const mapStateToProps = function (state) {
  let tableItems = state.wards.map(function(ward) {
    let numWardAccounts = state.wardAccounts.filter(wardAccount => {
      return ward.id == wardAccount.wardId;
    }).length;

    return Object.assign({}, ward, {
      numWardAccounts: numWardAccounts
    });
  });

  return {
    tableItems: tableItems,
    wardFocus: state.ui.wardFocus,
    formModal: state.ui.formModal,
    formValues: state.modalForm.formValues,
    channel: state.session.socket ? state.session.socket.channels[0] : undefined
  };
};

const mapDispatchToProps = function (dispatch) {
  return bindActionCreators(ActionCreators, dispatch);
};

class WardList extends Component {
  deleteWard(id) {
    this.props.channel.push('delete_ward', {
      id: id
    });
  }

  renderResult(ward, key) {
    if (this.props.wardFocus == ward.id) {
      return (
        <tr className="selected" key={key}>
          <ConfirmModal
            name={'wardList' + ward.id}
            body={'Are you sure you want to delete ' + ward.name + '?'}
            proceed={() => this.deleteWard(ward.id)}
            cancel={() => this.props.closeConfirmModal()}
          />
          <td className="text-link" onClick={() => this.props.clearWardFocus()}>{ward.name}</td>
          <td className="text-link" onClick={() => this.props.clearWardFocus()}>{ward.numWardAccounts}</td>
          <td>
            <EditButton
              name="editWard"
              btnText="Edit"
              values={ward}
            />
            &nbsp;
            <button className="btn btn-xs btn-danger" onClick={() => this.props.openConfirmModal('wardList' + ward.id)}>Delete</button>
          </td>
        </tr>
      );
    } else {
      return (
        <tr key={key}>
          <ConfirmModal
            name={'wardList' + ward.id}
            body={'Are you sure you want to delete ' + ward.name + '?'}
            proceed={() => this.deleteWard(ward.id)}
            cancel={() => this.props.closeConfirmModal()}
          />
          <td className="text-link" onClick={() => this.props.setWardFocus(ward.id)}>{ward.name}</td>
          <td className="text-link" onClick={() => this.props.setWardFocus(ward.id)}>{ward.numWardAccounts}</td>
          <td>
            <EditButton
              name="editWard"
              btnText="Edit"
              values={ward}
            />
            &nbsp;
            <button className="btn btn-xs btn-danger" onClick={() => this.props.openConfirmModal('wardList' + ward.id)}>Delete</button>
          </td>
        </tr>
      );
    }
  }

  renderResults() {
    if (this.props.tableItems.length != 0) {
      return this.props.tableItems.map(this.renderResult.bind(this));
    } else {
      return (
        <tr>
          <td colSpan="3"><i>No results</i></td>
        </tr>
      );
    }
  }

  submitForm(values) {
    this.props.clearFormErrors();
    let valid = true;

    if (!values || !values.name) {
      this.props.addFormError('name', 'Cannot be blank');
      valid = false;
    }
    if (!values || !values.relationship) {
      this.props.addFormError('relationship', 'Cannot be blank');
      valid = false;
    }

    if (valid) {
      switch (this.props.formModal) {
        case 'addWard':
          this.props.channel.push('create_ward', {ward_params: {
            name: values.name,
            relationship: values.relationship,
            active: values.active || true
          }});
          break;
        case 'editWard':
          this.props.channel.push('update_ward', {id: this.props.formValues.id, updated_params: {
            name: values.name,
            relationship: values.relationship,
            active: values.active
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
          name="addWard"
          onSubmit={this.submitForm.bind(this)}
          inputs={[
            {type: 'text', name: 'name', text: 'Name', focus: true},
            {type: 'text', name: 'relationship', text: 'Relationship'},
            {type: 'select', name: 'active', text: 'Active', selectObjects: [{text: 'yes', value: true}, {text: 'no', value: false}]}
          ]}
          title="Add Ward"
          instructions="Enter a name and a relationship (optional) for your new ward. The name should be unique and does not need to be a handle for a specific social media account. Relationship should reflect the ward's relationship to you. Select if this ward is active or not."
        />
        <FormModal
          name="editWard"
          onSubmit={this.submitForm.bind(this)}
          inputs={[
            {type: 'text', name: 'name', text: 'Name', focus: true},
            {type: 'text', name: 'relationship', text: 'Relationship'},
            {type: 'select', name: 'active', text: 'Active', selectObjects: [{text: 'yes', value: true}, {text: 'no', value: false}]}
          ]}
          title="Edit Ward"
          instructions="Edit the name and relationship (optional) for this ward. The name should be unique and does not need to be a handle for a specific social media account. Relationship should reflect the ward's relationship to you. Select if this ward is active or not."
        />
        <table className="table table-hover">
          <thead>
            <tr>
              <th>Name</th>
              <th># Accts</th>
              <th>Options</th>
            </tr>
          </thead>
          <tbody>
            {this.renderResults()}
          </tbody>
        </table>
        <div className="pull-right">
          <AddButton
            name="addWard"
            btnText="Add Ward..."
          />
        </div>
        <br />
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(WardList);
