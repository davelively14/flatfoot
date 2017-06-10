import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as ActionCreators from '../../../actions/index';

import EditButton from '../shared/edit_button';
import FormModal from '../shared/form_modal';

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

  submitForm(values) {
    console.log(values);
  }

  render() {
    let wardAccount = this.props.wardAccount;

    return(
      <div>
        {/* <FormModal
          name="editWardAccount"
          onSubmit={this.submitForm.bind(this)}
          inputs={[
            {type: 'text', name: 'handle', text: 'Handle', focus: true},
            {type: 'select', name: 'backend_id', text: 'Network', selectObjects: this.setBackendsSelect(this.props.backends)}
          ]}
        /> */}
        {wardAccount &&
          <div className="row">
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
              <button className="btn btn-danger btn-xs" onClick={() => this.deleteWardAccount(wardAccount.id)}>Delete</button>
            </div>
          </div>
        }
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(WardAccountDetail);
