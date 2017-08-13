import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../../../actions/index';

import EditButton from '../shared/edit_button';
import ConfirmModal from '../shared/confirm_modal';

const mapStateToProps = (state) => {
  let wardAccount = state.wardAccounts.filter(wardAccount => {
    return wardAccount.id == state.ui.wardAccountFocus;
  })[0];

  return {
    wardAccount: wardAccount,
    channel: state.session.socket ? state.session.socket.channels[0] : undefined
  };
};

const mapDispatchToProps = (dispatch) => {
  return bindActionCreators(ActionCreators, dispatch);
};

class WardAccountDetail extends Component {
  deleteWardAccount(id) {
    this.props.channel.push('delete_ward_account', {
      id: id
    });
  }

  clearResults() {
    this.props.channel.push('clear_ward_results', {
      ward_account_id: this.props.wardAccount.id
    });
  }

  render() {
    let wardAccount = this.props.wardAccount;

    return(
      <div>
        {wardAccount &&
          <div className="row">
            <ConfirmModal
              name={'wardAccount' + wardAccount.id}
              body={'Are you sure you want to delete ' + wardAccount.handle + '?'}
              proceed={() => this.deleteWardAccount(wardAccount.id)}
              cancel={() => this.props.closeConfirmModal()}
            />
            <h3>{wardAccount.handle}</h3>
            <div className="col-sm-8">
              <h4><small>{wardAccount.network}</small></h4>
            </div>
            <div className="col-sm-4">
              <EditButton
                name="editWardAccount"
                btnText="Edit"
                values={wardAccount}
              />
              &nbsp;
              <button className="btn btn-danger btn-xs" onClick={() => this.props.openConfirmModal('wardAccount' + wardAccount.id)}>Delete</button>
            </div>
            <br />
            <button className="btn btn-warning btn-block" onClick={() => this.clearResults()}>Clear results for {wardAccount.handle}</button>
          </div>
        }
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(WardAccountDetail);
