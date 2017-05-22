// TODO: stopped here, get Phoenix Token via the API. That should be
// incorporated into the login and new_user
import { Socket } from 'phoenix';

let socket = new Socket('/socket', {
  params: {token: window.userToken},
  logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data); }
});

export default socket;
