import wardAccounts from '../../../lib/flatfoot_web/static/js/reducers/ward_accounts';

const initialState = [];
const ADD_WARD_ACCOUNT = 'ADD_WARD_ACCOUNT', REMOVE_WARD_ACCOUNT = 'REMOVE_WARD_ACCOUNT', UPDATE_WARD_ACCOUNT = 'UPDATE_WARD_ACCOUNT', LOGOUT = 'LOGOUT', CLEAR_DASHBOARD = 'CLEAR_DASHBOARD';

// TODO: why does backend_module (snake case) stay in both the JS version and the in the passed from Elixir version?
var wardAccount1 = { id: 101, ward_id: 1, backend_module: 'Elixir.Twitter', handle: '@johnsmith', network: 'Twitter' };
var wardAccountJS1 = { id: 101, wardId: 1, backend_module: 'Elixir.Twitter', handle: '@johnsmith', network: 'Twitter' };
var updatedWardAccount1 = { id: 101, ward_id: 10, backend_module: 'Elixir.Twitter', handle: '@smithwicks', network: 'Twitter' };
var updatedWardAccountJS1 = { id: 101, wardId: 10, backend_module: 'Elixir.Twitter', handle: '@smithwicks', network: 'Twitter' };
var wardAccount2 = { id: 102, ward_id: 2, backend_module: 'Elixir.Twitter', handle: '@willsmith', network: 'Twitter' };
var wardAccountJS2 = { id: 102, wardId: 2, backend_module: 'Elixir.Twitter', handle: '@willsmith', network: 'Twitter' };

describe('wardAccounts', () => {
  it('should set default state to initialState', () => {
    expect(wardAccounts(undefined, {})).to.eql(initialState);
  });

  it('should return current state by default', () => {
    expect(wardAccounts(undefined, {type: 'NO_LEGIT_TYPE'})).to.eql(initialState);
    expect(wardAccounts([wardAccountJS2], {type: 'NO_LEGIT_TYPE'})).to.eql([wardAccountJS2]);
  });

  it('should add a ward account with ADD_WARD_ACCOUNT type and valid params', () => {
    expect(wardAccounts(undefined, {type: ADD_WARD_ACCOUNT, ward_account_params: wardAccount1})).to.eql([wardAccountJS1]);
    expect(wardAccounts([wardAccountJS1], {type: ADD_WARD_ACCOUNT, ward_account_params: wardAccount2})).to.eql([wardAccountJS1, wardAccountJS2]);
  });

  it('should ignore unrecognized ward results params with ADD_WARD_ACCOUNT type', () => {
    let verboseWardAccountParams = Object.assign({}, wardAccount1, {this: true, that: false});
    expect(wardAccounts(undefined, {type: ADD_WARD_ACCOUNT, ward_account_params: verboseWardAccountParams})).to.eql([wardAccountJS1]);
  });

  it('should remove a ward account with REMOVE_WARD_ACCOUNT type and valid id', () => {
    expect(wardAccounts([wardAccountJS1], {type: REMOVE_WARD_ACCOUNT, ward_account_id: wardAccount1.id})).to.eql([]);
  });

  it('should do nothing with REMOVE_WARD_ACCOUNT type and invalid id', () => {
    expect(wardAccounts([wardAccountJS1], {type: REMOVE_WARD_ACCOUNT, ward_account_id: 123210})).to.eql([wardAccountJS1]);
  });

  it('should update a ward account with UPDATE_WARD_ACCOUNT and valid params', () => {
    expect(wardAccounts([wardAccountJS1], {type: UPDATE_WARD_ACCOUNT, ward_account_params: updatedWardAccount1})).to.eql([updatedWardAccountJS1]);
  });

  it('should do nothing with UPDATE_WARD_ACCOUNT and params with invalid id', () => {
    expect(wardAccounts([wardAccountJS1], {type: UPDATE_WARD_ACCOUNT, ward_account_params: {id: 1231}})).to.eql([wardAccountJS1]);
  });

  it('should reset state to initialState with LOGOUT or CLEAR_DASHBOARD types', () => {
    expect(wardAccounts([wardAccountJS1, wardAccountJS2], {type: LOGOUT})).to.eql(initialState);
    expect(wardAccounts([wardAccountJS1, wardAccountJS2], {type: CLEAR_DASHBOARD})).to.eql(initialState);
  });

  it('should throw a TypeError if no object passed', () => {
    expect(wardAccounts.bind(undefined, undefined)).to.throw(TypeError);
  });
});
