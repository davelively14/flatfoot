import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../../../actions/index';

import WardAccountsList from './ward_accounts_list';
import ActivityFeed from './../shared/activity_feed';
import WardAccountDetail from './ward_account_detail';

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

class WardDetail extends Component {
  render() {
    return(
      <div>
        {this.props.ward &&
          <div>
            <h3>{this.props.ward.name} <small className="pull-right">{this.props.ward.active ? 'Active' : 'Inactive'}</small></h3>
            <h4><small>{this.props.ward.relationship}</small></h4>
            <div className="col-sm-4">
              <WardAccountsList
                wardAccounts={this.props.wardAccounts}
              />
            </div>
            <div className="col-sm-8">
              <WardAccountDetail />
              <hr />
              <ActivityFeed
                ward={this.props.ward}
                wardAccounts={this.props.wardAccounts}
                wardResults={this.props.wardResults}
              />
            </div>
          </div>
        }
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(WardDetail);
