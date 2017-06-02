import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../../../actions/index';

const mapStateToProps = (_state, ownProps) => {
  return {
    text: ownProps.text,
    type: ownProps.type
  };
};

const mapDispatchToProps = (dispatch) => {
  return bindActionCreators(ActionCreators, dispatch);
};

class AddButton extends Component {
  openModal() {
    this.props.openAddModal(this.props.type);
  }

  render() {
    return (
      <span className="btn btn-primary btn-xs" onClick={this.openModal.bind(this)}>Add {this.props.type}...</span>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(AddButton);
