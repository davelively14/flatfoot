import React from 'react';

export const fetchUser = (setUser, token) => {
  let uri = 'http://localhost:4000/';

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
      setUser(user.id, user.username, user.email);
    }
  );
};
