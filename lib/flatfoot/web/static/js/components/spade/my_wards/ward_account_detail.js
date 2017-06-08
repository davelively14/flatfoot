import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../../../actions/index';

const mapStateToProps = (state) => {
  let wardAccount = state.wardAccounts.filter(wardAccount => {
    return wardAccount.id == state.ui.wardAccountFocus;
  })[0];

  return {
    wardAccount: wardAccount
  };
};

const mapDispatchToProps = (dispatch) => {
  return bindActionCreators(ActionCreators, dispatch);
};

class WardAccountDetail extends Component {
  render() {
    console.log('Ward Account: ' +this.props.wardAccount);
    return(
      <div>
        {this.props.wardAccount &&
          <div className="row">
            <h3>{this.props.wardAccount.handle}</h3>
            <div className="col-sm-8">
              <h4><small>{this.props.wardAccount.network}</small></h4>
            </div>
            <div className="col-sm-4">
              <button className="btn btn-info btn-xs">Edit</button>
              &nbsp;
              <button className="btn btn-danger btn-xs">Delete</button>
            </div>
          </div>
        }
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(WardAccountDetail);
