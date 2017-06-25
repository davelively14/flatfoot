import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../../../actions/index';

const mapStateToProps = (_state, ownProps) => {
  return {
    name: ownProps.name,
    btnText: ownProps.btnText,
    specialClass: ownProps.specialClass || 'btn btn-primary btn-xs'
  };
};

const mapDispatchToProps = (dispatch) => {
  return bindActionCreators(ActionCreators, dispatch);
};

class AddButton extends Component {
  render() {
    return (
      <span className={this.props.specialClass} onClick={() => this.props.openFormModal(this.props.name)}>{this.props.btnText}</span>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(AddButton);
