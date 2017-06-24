import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import * as ActionCreators from '../../../actions/index';

const mapStateToProps = function (state, ownProps) {
  if (ownProps.noProps) {
    return {
      wards: state.wards,
      wardAccounts: state.wardAccounts,
      wardResults: state.wardResults,
      channel: state.session.socket ? state.session.socket.channels[0] : undefined
    };
  } else {
    return {
      wards: [ownProps.ward],
      wardAccounts: ownProps.wardAccounts,
      wardResults: ownProps.wardResults,
      channel: state.session.socket ? state.session.socket.channels[0] : undefined
    };
  }
};

const mapDispatchToProps = function (dispatch) {
  return bindActionCreators(ActionCreators, dispatch);
};

class ActivityFeed extends Component {
  getTimestamp(isoDTG) {
    const monthConversion = {0: 'Jan', 1: 'Feb', 2: 'Mar', 3: 'Apr', 4: 'May', 5: 'Jun', 6: 'Jul', 7: 'Aug', 8: 'Sep', 9: 'Oct', 10: 'Nov', 11: 'Dec'};
    let dtg = new Date(isoDTG);

    let hours = dtg.getHours();
    let minutes = dtg.getMinutes();
    let month = monthConversion[dtg.getMonth()];
    let meridiem = 'am';

    if (hours > 12) {
      hours = hours - 12;
      meridiem = 'pm';
    } else if (hours == 0) {
      hours = 12;
    }

    if (minutes < 10) {
      minutes = '0' + minutes;
    }

    return month + ' ' + dtg.getDate() + ', ' + dtg.getFullYear() + ' ' + hours + ':' + minutes + meridiem;
  }

  renderRating(rating) {
    switch (true) {
      case rating > 67:
        return ( 'panel panel-danger');
      case rating > 33:
        return ( 'panel panel-warning');
      case rating > 0:
        return ( 'panel panel-info');
      default:
        return ( 'panel panel-success' );
    }
  }

  removeResult(id, channel) {
    channel.push('clear_ward_result', {id: id});
  }

  renderResult(result, key) {
    let wardAccount = this.props.wardAccounts.filter(wardAccount => {
      return wardAccount.id == result.wardAccountId;
    })[0];

    let ward = this.props.wards.filter(ward => {
      return ward.id == wardAccount.wardId;
    })[0];

    return (
      <div className={this.renderRating(result.rating)} key={key}>
        <div className="panel-heading">
          <h4>{ward.name} ({wardAccount.handle}) <span className="pull-right badge">{result.rating}</span></h4>
          <span className="text-right">{wardAccount.network}</span>
        </div>
        <table className="table">
          <tbody>
            <tr>
              <td className="text-center"><strong>From</strong></td>
              <td>{result.from}</td>
            </tr>
            <tr>
              <td className="text-center"><strong>Body</strong></td>
              <td>{result.msgText}</td>
            </tr>
          </tbody>
        </table>
        <div className="panel-footer">
          {this.getTimestamp(result.timestamp)}
          <span className="pull-right btn btn-danger btn-xs" onClick={() => this.removeResult(result.id, this.props.channel)}>Delete</span>
        </div>
      </div>
    );
  }

  render() {
    return (
      <div>
        <h3>Activity Feed</h3>
        {this.props.wardResults.map(this.renderResult.bind(this))}
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(ActivityFeed);
