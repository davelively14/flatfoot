import wardResults from '../../../lib/flatfoot_web/static/js/reducers/ward_results';

const initialState = [];
const ADD_WARD_RESULT= 'ADD_WARD_RESULT', CLEAR_WARD_RESULTS = 'CLEAR_WARD_RESULTS', ADD_WARD_RESULTS = 'ADD_WARD_RESULTS', REMOVE_WARD_ACCOUNT = 'REMOVE_WARD_ACCOUNT', LOGOUT = 'LOGOUT', REMOVE_WARD_RESULT = 'REMOVE_WARD_RESULT', REMOVE_WARD_RESULTS = 'REMOVE_WARD_RESULTS', CLEAR_DASHBOARD = 'CLEAR_DASHBOARD';

var wardResult1   = {id: 101, rating: 90, from: '@johnsmith', msg_id: 1, msg_text: 'Hello there', ward_account_id: 1, backend_id: 1, timestamp: '2017-06-01'};
var wardResultJS1 = {id: 101, rating: 90, from: '@johnsmith', msgId: 1, msgText: 'Hello there', wardAccountId: 1, backendId: 1, timestamp: '2017-06-01'};
var wardResult2   = {id: 102, rating: 10, from: '@willsmith', msg_id: 2, msg_text: 'It\'s me again', ward_account_id: 2, backend_id: 1, timestamp: '2017-05-25'};
var wardResultJS2 = {id: 102, rating: 10, from: '@willsmith', msgId: 2, msgText: 'It\'s me again', wardAccountId: 2, backendId: 1, timestamp: '2017-05-25'};

describe('wardResults', () => {
  it('should set default state to initialState', () => {
    expect(wardResults(undefined, {})).to.eql(initialState);
  });

  it('should return current state by default', () => {
    expect(wardResults(undefined, {type: 'NO_LEGIT_TYPE'})).to.eql(initialState);
  });

  it('should add a ward result with ADD_WARD_RESULT type and ward_result_params', () => {
    expect(wardResults(undefined, {type: ADD_WARD_RESULT, ward_result_params: wardResult1})).to.eql([wardResultJS1]);
    expect(wardResults([wardResultJS1], {type: ADD_WARD_RESULT, ward_result_params: wardResult2})).to.eql([wardResultJS1, wardResultJS2]);
  });

  it('should ignore unrecognized ward_result_params with ADD_WARD_RESULT type', () => {
    let verboseWardResultParams = Object.assign({}, wardResult1, {this: false, that: true});
    expect(wardResults(undefined, {type: ADD_WARD_RESULT, ward_result_params: verboseWardResultParams})).to.eql([wardResultJS1]);
  });

  it('should add multiple ward results with ADD_WARD_RESULTS type and ward_results param', () => {
    expect(wardResults(undefined, {type: ADD_WARD_RESULTS, ward_results: [wardResult1, wardResult2]})).to.eql([wardResultJS1, wardResultJS2]);
  });

  it('should remove a ward result with REMOVE_WARD_RESULT type and valid ward_result.id', () => {
    expect(wardResults([wardResultJS1], {type: REMOVE_WARD_RESULT, ward_result: wardResult1})).to.eql(initialState);
  });

  it('should do nothing with REMOVE_WARD_RESULT type and invalid ward_result.id', () => {
    expect(wardResults([wardResultJS1], {type: REMOVE_WARD_RESULT, ward_result: {id: 120}})).to.eql([wardResultJS1]);
  });

  it('should remove multiple ward resutls with REMOVE_WARD_RESULTS type and valid ids', () => {
    expect(wardResults([wardResultJS1, wardResultJS2], {type: REMOVE_WARD_RESULTS, ward_results: [wardResult1, wardResult2]})).to.eql([]);
  });

  it('should only remove existing results with REMOVE_WARD_RESULTS type and valid/invalid ids', () => {
    expect(wardResults([wardResultJS1, wardResultJS2], {type: REMOVE_WARD_RESULTS, ward_results: [wardResult1, {id: 12313}]})).to.eql([wardResultJS2]);
  });

  it('should removes ward results for a ward account with REMOVE_WARD_ACCOUNT type', () => {
    expect(wardResults([wardResultJS1, wardResultJS2], {type: REMOVE_WARD_ACCOUNT, id: 1})).to.eql([wardResultJS2]);
  });

  it('should set state to initialState for LOGOUT, CLEAR_DASHBOARD, or CLEAR_WARD_RESULTS types', () => {
    expect(wardResults([wardResultJS1], {type: LOGOUT})).to.eql(initialState);
    expect(wardResults([wardResultJS1], {type: CLEAR_DASHBOARD})).to.eql(initialState);
    expect(wardResults([wardResultJS1], {type: CLEAR_WARD_RESULTS})).to.eql(initialState);
  });

  it('should throw a TypeError if no object passed', () => {
    expect(wardResults.bind(undefined, undefined)).to.throw(TypeError);
  });
});
