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

  // TODO: passes phoenixToken instead of phoenix_token? Just be consistent
  it('should assign phoenixToken the passed value with SET_PHOENIX_TOKEN type', () => {
    expect(session(initialState, {type: SET_PHOENIX_TOKEN, phoenixToken: 'asdf'}).phoenixToken).to.eq('asdf');
  });

  it('should assign undefined to phoenixToken with SET_PHOENIX_TOKEN type and no phoenixToken', () => {
    let startState = Object.assign({}, initialState, {phoenixToken: 'asdf'});
    expect(startState.phoenixToken).to.eq('asdf');
    expect(session(startState, {type: SET_PHOENIX_TOKEN}).phoenixToken).to.be.undefined;
  });

  it('should create and assign a socket object to socket with SET_SOCKET type and phoenixToken', () => {
    expect(session(initialState, {type: SET_SOCKET, phoenixToken: 'asdf'}).socket.params.token).to.eq('asdf');
  });

  it('should create and assign a socket object with SET_SOCKET type and no phoenixToken, but with empty token params', () => {
    expect(session(initialState, {type: SET_SOCKET}).socket.params.token).to.be.undefined;
  });

  it('should set socket to undefined with CLEAR_SOCKET type', () => {
    let startState = Object.assign({}, initialState, {socket: 'asdf'});
    expect(session(startState, {type: CLEAR_SOCKET}).socket).to.be.undefined;
  });

  it('should set state to initialState with LOGOUT type', () => {
    let startState = Object.assign({}, initialState, {token: 'asdf', phoenixToken: '1234', socket: 'somesocket'});
    expect(session(startState, {type: LOGOUT})).to.eql(initialState);
  });
});
