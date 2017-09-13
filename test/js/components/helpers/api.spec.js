import * as api from '../../../../lib/flatfoot_web/static/js/components/helpers/api';

describe('uri', () => {
  it('should return localhost (while in dev environment)', () => {
    expect(api.uri).to.eq('http://localhost:4000/');
  });
});
