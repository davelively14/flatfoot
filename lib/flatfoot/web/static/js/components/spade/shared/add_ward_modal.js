import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../../../actions/index';

import { Field, reduxForm } from 'redux-form';
import { renderFieldAndLabel, renderFieldAndLabelFocus } from '../../helpers/render_field';
import Modal from 'react-bootstrap-modal';

const mapStateToProps = (state) => {
  return {
    user: state.user,
    wards: state.wards,
    addModal: state.ui.addModal,
    formValues: state.modalForm.formValues
  };
};

const mapDispatchToProps = (dispatch) => {
  return bindActionCreators(ActionCreators, dispatch);
};

class AddWardModal extends Component {
  submitForm(values) {
    console.log(values);
  }

  updateFormValue(inputName, evt) {
    switch (inputName) {
      case 'name':
        this.props.setFormValues(Object.assign({}, this.props.formValues, {
          name: evt.target.value
        }));
        break;
      case 'relationship':
        this.props.setFormValues(Object.assign({}, this.props.formValues, {
          relationship: evt.target.value
        }));
        break;
      default:
        return undefined;
    }

  }

  render() {
    return (
      <Modal
        show={this.props.addModal ? true : false}
        onHide={this.props.closeAddModal}
        aria-labelledby="ModalHeader"
      >
        <Modal.Header closeButton>
          <Modal.Title id="ModalHeader">Add {this.props.addModal}</Modal.Title>
        </Modal.Header>
        {/* Break out individual ward vs. wardAccount forms */}
        <form onSubmit={this.submitForm}>
          <Modal.Body>
            <p><i>Instructions:</i> Enter a name and a relationship for your new ward. The name should be unique and does not need to be a handle for a social media account. Relationship should reflect the ward's relationship to you.</p>
            <div className="row">
              <div className="col-sm-8 col-sm-offset-2">
                <div className="form-group">
                  <div>
                    <label>Name</label>
                    <input
                      onChange={evt => this.updateFormValue('name', evt)}
                      placeholder="Name"
                      type="text"
                      className="form-control"
                    />
                  </div>
                </div>
                <div className="form-group">
                  <div>
                    <label>Relationship</label>
                    <input
                      onChange={evt => this.updateFormValue('relationship', evt)}
                      placeholder="Relationship"
                      type="text"
                      className="form-control"
                    />
                  </div>
                </div>
              </div>
            </div>
          </Modal.Body>
          <Modal.Footer>
            <span className="btn btn-default" onClick={this.props.closeAddModal}>Cancel</span>
            <button type="button" className="btn btn-primary" onClick={() => this.submitForm(this.props.formValues)}>Save</button>
          </Modal.Footer>
        </form>
      </Modal>
    );
  }
}

AddWardModal = reduxForm({
  form: 'add_ward_modal'
})(AddWardModal);

export default connect(mapStateToProps, mapDispatchToProps)(AddWardModal);
