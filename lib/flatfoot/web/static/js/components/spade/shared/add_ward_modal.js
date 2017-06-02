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
    addModal: state.ui.addModal
  };
};

const mapDispatchToProps = (dispatch) => {
  return bindActionCreators(ActionCreators, dispatch);
};

class AddWardModal extends Component {
  handleSubmit(_values) {
    
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
        <form onSubmit={this.handleSubmit}>
          <Modal.Body>
            <p><i>Instructions:</i> Enter a name and a relationship for your new ward. The name should be unique and does not need to be a handle for a social media account. Relationship should reflect the ward's relationship to you.</p>
            <div className="row">
              <div className="col-sm-8 col-sm-offset-2">
                <Field name="name" type="text" component={renderFieldAndLabelFocus} placeholder="Name" />
                <Field name="relationship" type="text" component={renderFieldAndLabel} placeholder="Relationship" />
              </div>
            </div>
          </Modal.Body>
          <Modal.Footer>
            <span className="btn btn-default" onClick={this.props.closeAddModal}>Cancel</span>
            <button type="submit" className="btn btn-primary">Save</button>
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
