import { SubmissionError } from 'redux-form';
import { browserHistory } from 'react-router';

// export const uri = 'https://obscure-reef-78695.herokuapp.com/';
export const uri = 'http://localhost:4000/';

const getAuthorizationHeader = (token) => {
  let headers = new Headers();
  headers.append('Authorization', 'Token token="' + token + '"');
  return headers;
};

export const fetchUser = (setUser, token) => {
  fetch(uri + 'api/users/token?token=' + token, {
    method: 'get'
  }).then(
    function(response) {
      if (response.status != 200) {
        throw 'Invalid user token';
      }

      return response.text();
    }
  ).then(
    function(text) {
      let user = JSON.parse(text).data;
      setUser(user.id, user.username, user.email, user.global_threshold);
    }
  );
};

export const fetchPhoenixToken = (setPhoenixToken, token) => {
  let headers = getAuthorizationHeader(token);

  fetch(uri + 'api/token', {
    method: 'get',
    headers: headers
  }).then(
    function(response) {
      if (response.status != 200) {
        throw 'Invalid token';
      }

      return response.text();
    }
  ).then(
    function(text) {
      let phoenixToken = JSON.parse(text).token;
      setPhoenixToken(phoenixToken);
    }
  );
};

export const validateUser = (token, username, password) => {
  let headers = getAuthorizationHeader(token);

  fetch(uri + 'api/users/validate?username=' + username + '&password=' + password, {
    method: 'get',
    headers: headers
  }).then(
    function(response) {
      if (response.status != 200) {
        throw 'Invalid parameters. Must pass username and password.';
      }

      return response.text();
    }
  ).then(
    function(text) {
      let result = JSON.parse(text);

      if (result.authorized) {
        return true;
      } else {
        return false;
      }
    }
  );
};

export const updateUser = (setUser, toggleUserEdit, token, userParams) => {
  let fetchStr = uri + 'api/users?token=' + token;

  for (var param in userParams) {
    if (userParams.hasOwnProperty(param)) {
      fetchStr = fetchStr + '&user_params[' + param + ']=' + userParams[param];
    }
  }

  fetch(fetchStr, {
    method: 'put',
    headers: getAuthorizationHeader(token)
  }).then(
    function(response) {
      if (response.status != 200) {
        throw 'Error! User update not saved.';
      }

      return response.text();
    }
  ).then(
    function(text) {
      let user = JSON.parse(text).data;
      setUser(user.id, user.username, user.email, user.global_threshold);
      toggleUserEdit();
    }
  );
};
