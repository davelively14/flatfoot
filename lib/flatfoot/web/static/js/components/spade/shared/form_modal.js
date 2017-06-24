import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../../../actions/index';

import Modal from 'react-bootstrap-modal';
import InputText from './form_modal/input_text';
import InputSelect from './form_modal/input_select';

const mapStateToProps = (state, ownProps) => {
  return {
    handleSubmit: ownProps.onSubmit,
    inputs: ownProps.inputs,
    name: ownProps.name,
    title: ownProps.title,
    instructions: ownProps.instructions,
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
  renderInputs(inputs) {
    let results = [];

    inputs.forEach(input => {
      switch (input.type) {
        case 'text':
          results.push(<InputText name={input.name} placeholder={input.text} focus={input.focus} key={input.name} />);
          break;
        case 'select':
          results.push(<InputSelect name={input.name} placeholder={input.text} selectObjects={input.selectObjects} focus={input.focus} key={input.name} />);
          break;
        default:
          break;
      }
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
          <Modal.Title id="ModalHeader">{this.props.title}</Modal.Title>
        </Modal.Header>
        <form>
          <Modal.Body>
            <p><i>Instructions:</i> {this.props.instructions}</p>
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
