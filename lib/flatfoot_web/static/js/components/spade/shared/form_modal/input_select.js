import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../../../../actions/index';

const mapStateToProps = (state, ownProps) => {
  return {
    name: ownProps.name,
    placeholder: ownProps.placeholder,
    focus: ownProps.focus || false,
    selectObjects: ownProps.selectObjects || [{text: undefined, value: undefined}],
    formValues: state.modalForm.formValues || {},
    formErrors: state.modalForm.formErrors || {}
  };
};

const mapDispatchToProps = (dispatch) => {
  return bindActionCreators(ActionCreators, dispatch);
};

class InputSelect extends Component {
  componentWillMount() {
    if (!this.props.formValues[this.props.name] && this.props.selectObjects[0].value) {
      this.props.addFormValue(this.props.name, this.props.selectObjects[0].value);
    }
  }

  renderOption(map) {
    let results = [];

    map.forEach((map, value) => {
      results.push(<option value={map.value} key={value}>{map.text}</option>);
    });

    return results;
  }

  renderInputSelect(name, selectObjects, placeholder, focus = false) {
    if (this.props.formErrors[name]) {
      return this.renderErrorInputSelect(name, selectObjects, placeholder, this.props.formErrors[name]);
    } else {
      return (
        <div className="form-group">
          <label className="control-label">{placeholder}</label>
          {focus &&
            <select
              onChange={evt => this.props.addFormValue(name, evt.target.value)}
              className="form-control"
              value={this.props.formValues[name]}
              autoFocus
            >
              {this.renderOption(this.props.selectObjects)}
            </select>
            ||
            <select
              onChange={evt => this.props.addFormValue(name, evt.target.value)}
              className="form-control"
              value={this.props.formValues[name]}
            >
              {this.renderOption(this.props.selectObjects)}
            </select>
          }
        </div>
      );
    }
  }

  renderErrorInputSelect(name, selectObjects, placeholder, errorMsg) {
    return (
      <div className="form-group has-error" key={name}>
        <div>
          <label className="control-label">{placeholder}</label>
          <select
            onChange={evt => this.props.addFormValue(name, evt.target.value)}
            className="form-control"
            value={this.props.formValues[name]}
            aria-describedby={name + 'HelpBlock'}
          >
            {this.props.selectObjects.forEach(map => this.renderOption(map))}
          </select>
        </div>
        <span id={name + 'HelpBlock'} className="help-block">{errorMsg}</span>
      </div>
    );
  }

  render() {
    return(
      this.renderInputSelect(this.props.name, this.props.selectObjects, this.props.placeholder, this.props.focus)
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(InputSelect);
