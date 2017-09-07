import user from '../../../lib/flatfoot_web/static/js/reducers/user';

const initialState = {
  email: undefined,
  username: undefined,
  globalThreshold: 0
};
const SET_USER = 'SET_USER', LOGOUT = 'LOGOUT';

var userObj = {id: 1, email: 'jon@smith.com', username: 'jonsmith', globalThreshold: 50};

describe('user', () => {
  it('should set default state to initialState', () => {
    expect(user(undefined, {})).to.eql(initialState);
  });

  it('should return current state by default', () => {
    expect(user(undefined, {type: 'NO_LEGIT_TYPE'})).to.eql(initialState);
  });

  // TODO: user params should be passed separately: {type: ..., user_params: ...}
  it('should set current user with SET_USER type and valid user object', () => {
    expect(user(undefined, Object.assign({}, {type: SET_USER}, userObj))).to.eql(userObj);
  });

  it('should ignore unrecognized params with SET_USER type and otherwise valid user object', () => {
    expect(user(undefined, Object.assign({}, {type: SET_USER, this: true, that: false}, userObj))).to.eql(userObj);
  });

  it('should reset state to initialState with LOGOUT type', () => {
    expect(user(userObj, {type: LOGOUT})).to.eql(initialState);
  });
});
