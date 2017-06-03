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
    formValues: state.modalForm.formValues,
    formErrors: state.modalForm.formErrors || {}
  };
};

const mapDispatchToProps = (dispatch) => {
  return bindActionCreators(ActionCreators, dispatch);
};

class AddWardModal extends Component {
  submitForm(values) {
    if (values.name != 'hello') {
      this.props.setFormErrors(Object.assign({}, this.props.formErrors, {
        name: 'Not the right one'
      }));
    }
    console.log(values);
  }

  updateFormValue(inputName, evt) {
    let newValue = {};
    newValue[inputName] = evt.target.value;
    this.props.setFormValues(Object.assign({}, this.props.formValues, newValue));
  }

  renderInputText(name, placeholder) {
    if (this.props.formErrors[name]) {
      return this.renderErrorInputText(name, placeholder, this.props.formErrors[name]);
    } else {
      return (
        <div className="form-group">
          <div>
            <label className="control-label">{placeholder}</label>
            <input
              onChange={evt => this.updateFormValue(name, evt)}
              placeholder={placeholder}
              type="text"
              className="form-control"
            />
          </div>
        </div>
      );
    }
  }

  renderErrorInputText(name, placeholder, errorMsg) {
    return (
      <div className="form-group has-error">
        <div>
          <label className="control-label">{placeholder}</label>
          <input
            onChange={evt => this.updateFormValue(name, evt)}
            placeholder={placeholder}
            type="text"
            className="form-control"
            aria-describedby={name + 'HelpBlock'}
          />
        </div>
        <span id={name + 'HelpBlock'} className="help-block">{errorMsg}</span>
      </div>
    );
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
                {this.renderInputText('name', 'Name')}
                {this.renderInputText('relationship', 'Relationship')}
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

export default connect(mapStateToProps, mapDispatchToProps)(AddWardModal);
