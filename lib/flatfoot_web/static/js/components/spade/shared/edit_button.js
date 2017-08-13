import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../../../actions/index';

const mapStateToProps = (_state, ownProps) => {
  return {
    name: ownProps.name,
    btnText: ownProps.btnText,
    values: ownProps.values
  };
};

const mapDispatchToProps = (dispatch) => {
  return bindActionCreators(ActionCreators, dispatch);
};

class EditButton extends Component {
  openFormAndLoadValues(values, name) {
    this.props.setFormValues(values);
    this.props.openFormModal(name);
  }

  render() {
    return (
      <span className="btn btn-info btn-xs" onClick={() => this.openFormAndLoadValues(this.props.values, this.props.name)}>{this.props.btnText}</span>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(EditButton);
