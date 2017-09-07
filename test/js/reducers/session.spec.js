import session from '../../../lib/flatfoot_web/static/js/reducers/session';

var initialState = {
  token: undefined,
  phoenixToken: undefined,
  socket: undefined
};

const SET_TOKEN = 'SET_TOKEN', SET_PHOENIX_TOKEN = 'SET_PHOENIX_TOKEN', SET_SOCKET = 'SET_SOCKET', CLEAR_SOCKET = 'CLEAR_SOCKET', LOGOUT = 'LOGOUT';

describe('session', () => {
  it('should set default state to initialState', () => {
    expect(session(undefined, {})).to.eql(initialState);
  });

  it('should return current state by default', () => {
    expect(session(initialState, {type: 'NO_LEGIT_TYPE'})).to.eql(initialState);
  });

  it('should assign passed token value to token with SET_TOKEN type', () => {
    expect(session(initialState, {type: SET_TOKEN, token: 'asdf'}).token).to.eq('asdf');
  });

  it('should assign undefined to token with SET_TOKEN type and no token', () => {
    let startState = Object.assign({}, initialState, {token: 'asdf'});
    expect(startState.token).to.eq('asdf');
    expect(session(startState, {type: SET_TOKEN}).token).to.be.undefined;
  });
});
