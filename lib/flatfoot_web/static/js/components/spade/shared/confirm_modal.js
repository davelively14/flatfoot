import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../../../actions/index';

import Modal from 'react-bootstrap-modal';

const mapStateToProps = (state, ownProps) => {
  return {
    name: ownProps.name,
    body: ownProps.body,
    proceed: ownProps.proceed,
    cancel: ownProps.cancel,
    show: state.ui.confirmModal
  };
};

class ConfirmModal extends Component {
  render() {
    return (
      <Modal
        show={this.props.show == this.props.name}
        onHide={this.props.closeConfirmModal}
      >
        <Modal.Header closeButton>
          <Modal.Title id="ModalHeader">Please confirm</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          {this.props.body}
        </Modal.Body>
        <Modal.Footer>
          <button type="button" className="btn btn-default" onClick={this.props.cancel}>No</button>
          <button type="button" className="btn btn-primary" onClick={this.props.proceed}>Yes</button>
        </Modal.Footer>
      </Modal>
    );
  }
}

export default connect(mapStateToProps, {})(ConfirmModal);
