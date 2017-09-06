// We can use import since webpack knows how to find source references.
import { getSpecialValue } from './filea.js';

// describe and it are BDD structures provided by mocha.
// This is the tested module.
describe('filea', function() {

  // This is the tested function.
  describe('getSpecialValue', function() {

    // This is the spec
    it('returns a special value', function() {
      expect(getSpecialValue()).to.equal(10);
    });

  });

});
