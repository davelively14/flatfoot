import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../../actions/index';

const mapStateToProps = (state) => {
  let ward = state.wards.filter(ward => {
    return ward.id == state.ui.wardFocus;
  })[0];

  let wardAccounts = [];
  let wardResults = [];

  state.wardAccounts.forEach(wardAccount => {
    if (ward && wardAccount.wardId == ward.id) {
      wardAccounts.push(wardAccount);
      let results = state.wardResults.filter(wardResult => {
        return wardResult.wardAccountId == wardAccount.id;
      });
      wardResults = wardResults.concat(results);
    }
  });

  return {
    ward: ward,
    wardAccounts: wardAccounts,
    wardResults: wardResults
  };
};

const mapDispatchToProps = (dispatch) => {
  return bindActionCreators(ActionCreators, dispatch);
};

class WardFocus extends Component {
  render() {
    return(
      <div>
        {this.props.ward &&
          <div>
            <h3>{this.props.ward.name}</h3>
            <h4><small>{this.props.ward.relationship}</small></h4>
          </div>
        }
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(WardFocus);
