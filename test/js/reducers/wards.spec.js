import wards from '../../../lib/flatfoot_web/static/js/reducers/wards';

const initialState = [];
const ADD_WARD = 'ADD_WARD', REMOVE_WARD = 'REMOVE_WARD', UPDATE_WARD = 'UPDATE_WARD', LOGOUT = 'LOGOUT', CLEAR_DASHBOARD = 'CLEAR_DASHBOARD';

var wardParams1 = {id: 1, name: 'Dave Lively', relationship: 'father', active: true};
var updatedWardParams1 = {id: 1, name: 'Dave Johnson', relationship: 'father', active: true};
var wardParams2 = {id: 2, name: 'Wendy Smith', relationship: 'mother', active: true};

describe('wards', () => {
  it('should set default state to initialState', () => {
    expect(wards(undefined, {})).to.eql(initialState);
  });

  it('should return current state by default', () => {
    expect(wards(undefined, {type: 'NO_LEGIT_TYPE'})).to.eql(initialState);
  });

  it('should add a ward to the current state with ADD_WARD type', () => {
    expect(wards(undefined, {type: ADD_WARD, ward_params: wardParams1})).to.eql([wardParams1]);
    expect(wards([wardParams1], {type: ADD_WARD, ward_params: wardParams2})).to.eql([wardParams1, wardParams2]);
  });

  it('ignores unrecognized params from passed ward_params with ADD_WARD type', () => {
    let verboseWardParams = Object.assign({}, wardParams1, {nothing: true, num: 5});
    expect(wards(undefined, {type: ADD_WARD, ward_params: verboseWardParams})).to.eql([wardParams1]);
  });

  it('should remove a ward from the current state with REMOVE_WARD type', () => {
    expect(wards([wardParams1], {type: REMOVE_WARD, ward_id: wardParams1.id})).to.eql([]);
  });

  it('should do nothing if bad id passed with REMOVE_WARD type', () => {
    expect(wards([wardParams1], {type: REMOVE_WARD, ward_id: wardParams2.id})).to.eql([wardParams1]);
  });

  it('should update params of a particular ward entry with UPDATE_WARD type', () => {
    expect(wards([wardParams1, wardParams2], {type: UPDATE_WARD, ward_params: updatedWardParams1})).to.eql([updatedWardParams1, wardParams2]);
  });

  it('should do nothing with UPDATE_WARD type and passed a ward without an already existing id', () => {
    expect(wards([wardParams1, wardParams2], {type: UPDATE_WARD, ward_params: {id: 4}})).to.eql([wardParams1, wardParams2]);
  });

  it('should set state to default with LOGOUT type', () => {
    expect(wards([wardParams1], {type: LOGOUT})).to.eql(initialState);
  });

  it('should set state to default with CLEAR_DASHBOARD type', () => {
    expect(wards([wardParams1], {type: CLEAR_DASHBOARD})).to.eql(initialState);
  });

  it('should throw a TypeError if no object passed', () => {
    expect(wards.bind(undefined, undefined)).to.throw(TypeError);
  });
});
