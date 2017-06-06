import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../../../actions/index';

import Modal from 'react-bootstrap-modal';

const mapStateToProps = (state, ownProps) => {
  return {
    handleSubmit: ownProps.onSubmit,
    inputs: ownProps.inputs,
    name: ownProps.name,
    user: state.user,
    wards: state.wards,
    formModal: state.ui.formModal,
    formValues: state.modalForm.formValues || {},
    formErrors: state.modalForm.formErrors || {}
  };
};

const mapDispatchToProps = (dispatch) => {
  return bindActionCreators(ActionCreators, dispatch);
};

class FormModal extends Component {
  renderInputText(name, placeholder, focus = false) {
    if (this.props.formErrors[name]) {
      return this.renderErrorInputText(name, placeholder, this.props.formErrors[name]);
    } else {
      return (
        <div className="form-group" key={name}>
          <div>
            <label className="control-label">{placeholder}</label>
            {focus &&
              <input
                onChange={evt => this.props.addFormValue(name, evt.target.value)}
                placeholder={placeholder}
                type="text"
                className="form-control"
                value={this.props.formValues[name]}
                autoFocus
              />
              ||
              <input
                onChange={evt => this.props.addFormValue(name, evt.target.value)}
                placeholder={placeholder}
                type="text"
                className="form-control"
                value={this.props.formValues[name]}
              />
            }
          </div>
        </div>
      );
    }
  }

  renderErrorInputText(name, placeholder, errorMsg) {
    return (
      <div className="form-group has-error" key={name}>
        <div>
          <label className="control-label">{placeholder}</label>
          <input
            onChange={evt => this.props.addFormValue(name, evt.target.value)}
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

  renderInputs(inputs) {
    let results = [];

    inputs.forEach(input => {
      results.push(this.renderInputText(input.name, input.text, input.focus));
    });

    return (
      <div>
        {results}
      </div>
    );
  }

  render() {
    return (
      <Modal
        show={this.props.formModal == this.props.name ? true : false}
        onHide={this.props.closeFormModal}
        aria-labelledby="ModalHeader"
      >
        <Modal.Header closeButton>
          <Modal.Title id="ModalHeader">Add {this.props.name}</Modal.Title>
        </Modal.Header>
        <form>
          <Modal.Body>
            <p><i>Instructions:</i> Enter a name and a relationship for your new ward. The name should be unique and does not need to be a handle for a social media account. Relationship should reflect the ward's relationship to you.</p>
            <div className="row">
              <div className="col-sm-8 col-sm-offset-2">
                {this.renderInputs(this.props.inputs)}
              </div>
            </div>
          </Modal.Body>
          <Modal.Footer>
            <span className="btn btn-default" onClick={this.props.closeFormModal}>Cancel</span>
            <button type="button" className="btn btn-primary" onClick={() => this.props.handleSubmit(this.props.formValues)}>Save</button>
          </Modal.Footer>
        </form>
      </Modal>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(FormModal);