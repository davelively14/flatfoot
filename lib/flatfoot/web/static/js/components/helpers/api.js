import React from 'react';

const uri = 'http://localhost:4000/';

export const fetchUser = (setUser, token) => {
  fetch(uri + 'api/users/token?token=' + token, {
    method: 'get'
  }).then(
    function(response) {
      if (response.status != 200) {
        throw 'Invalid user_id';
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

// TODO create "validate user" function

export const updateUser = (setUser, token, userParams) => {
  let fetchStr = uri + 'api/users?token=' + token;

  for (var param in userParams) {
    if (userParams.hasOwnProperty(param)) {
      fetchStr = fetchStr + '&user_params[' + param + ']=' + userParams[param];
    }
  }

  return fetchStr;
};
