import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../../../../actions/index';

const mapStateToProps = (state, ownProps) => {
  return {
    name: ownProps.name,
    placeholder: ownProps.placeholder,
    focus: ownProps.focus || false,
    formValues: state.modalForm.formValues || {},
    formErrors: state.modalForm.formErrors || {}
  };
};

const mapDispatchToProps = (dispatch) => {
  return bindActionCreators(ActionCreators, dispatch);
};

class InputText extends Component {
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

  render() {
    return(
      this.renderInputText(this.props.name, this.props.placeholder, this.props.focus)
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(InputText);
