import backends from '../../../lib/flatfoot_web/static/js/reducers/backends';

const initialState = [];
const SET_BACKENDS = 'SET_BACKENDS';
const LOGOUT = 'LOGOUT';

describe('backends', () => {
  it('should set default state to initialState', () => {
    expect(backends(undefined, {})).to.eql(initialState);
  });

  it('should return state by default', () => {
    expect(backends(undefined, {type: 'JOHNSON_CITY_TN'})).to.eql(initialState);
  });

  it('should return to initial state with LOGOUT type', () => {
    expect(backends(['Some state'], {})).to.eql(['Some state']);
    expect(backends(['Some state'], {type: LOGOUT})).to.eql(initialState);
  });

  it('should set state to passed backends with SET_BACKENDS type', () => {
    let set_backends = ['one', 'two'];
    expect(backends(undefined, {type: SET_BACKENDS, backends: set_backends})).to.eql(set_backends);
  });

  it('should throw a TypeError if no object passed', () => {
    expect(backends.bind(undefined, undefined)).to.throw(TypeError);
  });
});
