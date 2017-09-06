import backends from '../../../lib/flatfoot_web/static/js/reducers/backends';

const initialState = [];
const SET_BACKENDS = 'SET_BACKENDS';
const LOGOUT = 'LOGOUT';

describe('backends', () => {
  it('should set default state to initialState', () => {
    expect(backends(undefined, {})).to.eql(initialState);
  });

  it('should return to initial state when LOGOUT called', () => {
    expect(backends(['Some state'], {})).to.eql(['Some state']);
    expect(backends(['Some state'], {type: LOGOUT})).to.eql(initialState);
  });

  it('should set state to passed backends', () => {
    let set_backends = ['one', 'two'];
    expect(backends(undefined, {type: SET_BACKENDS, backends: set_backends})).to.eql(set_backends);
  });
});
