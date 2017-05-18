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
      setUser(user.id, user.username, user.email);
    }
  );
};

export const fetchSettings = (setSettings, token) => {
  let headers = new Headers();
  headers.append('Authorization', 'Token token="' + token + '"');

  fetch(uri + 'api/settings', {
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
      let settings = JSON.parse(text).data;
      setSettings(settings.global_threshold);
    }
  );
};
