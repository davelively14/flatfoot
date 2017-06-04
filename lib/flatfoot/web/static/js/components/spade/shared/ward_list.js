import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../../../actions/index';

import AddButton from './add_button';
import FormModal from './form_modal';

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
    wardFocus: state.ui.wardFocus
  };
};

const mapDispatchToProps = function (dispatch) {
  return bindActionCreators(ActionCreators, dispatch);
};

class WardList extends Component {
  renderResult(ward, key) {
    if (this.props.wardFocus == ward.id) {
      return (
        <tr className="text-link selected" key={key} onClick={() => this.props.clearWardFocus()}>
          <td>{ward.name}</td>
          <td>{ward.numWardAccounts}</td>
          <td>TBD</td>
        </tr>
      );
    } else {
      return (
        <tr className="text-link" key={key} onClick={() => this.props.setWardFocus(ward.id)}>
          <td>{ward.name}</td>
          <td>{ward.numWardAccounts}</td>
          <td>TBD</td>
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
      console.log('Valid form');
      console.log(values);
      this.props.closeFormModal();
      this.props.clearFormValues();
    }
  }

  render() {
    return(
      <div>
        <FormModal
          name="addWard"
          onSubmit={this.submitForm.bind(this)}
          inputs={[
            {name: 'name', text: 'Name', focus: true },
            {name: 'relationship', text: 'Relationship'}
          ]}
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
          <span className="btn btn-primary btn-xs" onClick={() => this.props.openFormModal('addWard')}>Add Ward...</span>
          {/* <AddButton type="Ward" /> */}
        </div>
        <br />
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(WardList);
