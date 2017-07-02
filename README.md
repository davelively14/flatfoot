# Flatfoot
[![Build Status](https://travis-ci.org/davelively14/flatfoot.svg?branch=master)](https://travis-ci.org/davelively14/flatfoot) &nbsp;&nbsp;[View Heroku Demo](https://obscure-reef-78695.herokuapp.com/)

Monitors and reports if someone you are tracking is a victim of cyberbullying or making cries for help.

## Table of Contents

* [Documentation links](#docs)
* [Intro](#intro)
* [Demo installation instructions](#install)
* [Getting started](#getting-started)
* [Live Demo](#demo)

## <a name="docs"></a>Documentation links

* [JSON API docs](https://github.com/davelively14/flatfoot/blob/master/JSON_api.md)
* [SpadeChannel docs](https://github.com/davelively14/flatfoot/blob/master/spade_channel.md)

## <a name="intro"></a>Intro

This is my capstone project for the Web Development portion of my [Software Developer Track](https://www.bloc.io/software-developer-track) by [Bloc](https://www.bloc.io/). The idea for my capstone came from my wife. After one of those senseless social-media announced teenage suicides in response to online bullying, my wife suggested that I develop an app where parents could monitor their kids social media public feeds for signs of bullying or suicide ideation.

In order to limit the scope of an already large project, I chose to narrow the focus a little. Users would be able to monitor specific Twitter accounts. Other backends for other social network sites could be added later as time and resources permit.  I would also postpone the development of the mailer that would push updates.

When it came to picking the tech stack for this project, my mentor, Ryan Milstead, recommended that I use something I wanted to. There wasn’t anything particularly wrong with Rails, JQuery, or AngularJS, but with an open sandbox and my pick of tools, I settled on two technologies: Elixir with Phoenix (for the web interface layer) on the backend and React with Redux for the frontend demonstration.

In order to develop a wider variety of skills in this academic setting, I chose to use two different Phoenix endpoints for my client interaction layer: a JSON API endpoint for handling all things related to the user profile and authentication, and [famous](http://www.phoenixframework.org/blog/the-road-to-2-million-websocket-connections) Phoenix Channels to manage websocket connections that exposes social media monitoring functionality to the user.

## <a name="install"></a>Demo installation instructions

Note that in order to run this yourself, you'll need a [Twitter dev account](https://dev.twitter.com/).

* Clone or download this repo.
* Once on your machine, ensure that you add any login and password requirements for Postgres on your machine in the `config/dev.exs` and `config/test.exs` if necessary.

```elixir
# Configure your database
config :flatfoot, Flatfoot.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "flatfoot_dev",
  hostname: "localhost",
  pool_size: 10
```
* Create a file called `config/dev.secret.exs` and populate with the following (this is where you'll put your Twitter dev account info):

```elixir
use Mix.Config

config :flatfoot, :twitter, api_key: "YOUR_KEY_HERE"
config :flatfoot, :twitter, secret_key: "YOUR_KEY_HERE"
config :flatfoot, :twitter, base_64: "YOUR_KEY_HERE"
config :flatfoot, :twitter, token: "YOUR_KEY_HERE"
```
* Open `lib/flatfoot/web/static/js/components/helpers/api.js` and change the value of the constant `uri` to `http://localhost:4000`:

```javascript
import { SubmissionError } from 'redux-form';
import { browserHistory } from 'react-router';

export const uri = 'http://localhost:4000/';
...
```

* From the root directory, run: `mix deps.get`
* From the root directory, run: `mix ecto.migrate`
* Navigate to the `/assets` directory and run: `npm install`
* Navigate back to the root directory and run: `mix phx.server`

## <a name="getting-started"></a>Getting started

In order to get a basic token, the client must either create an account or login to an existing account.

To create an account, use the `api/new_user POST` call with required parameters:
```javascript
createUser = (username, password, email) => {
  let uri = 'http://localhost:4000/';
  let token = undefined;

  fetch(uri + 'api/new_user?user_params[username]=' + username +
        '&user_params[password]='+ password +
        '&user_params[email]=' + email,
        {
          method: 'post'
        }
  ).then(
    function(response) {
      return response.text();
    }
  ).then(
    function(text) {
      token = JSON.parse(text).data.token
    }
  );

  return token;
};
```

If you already have an existing account, get an authorization token by logging in via the `api/login POST` call with valid parameters:
```javascript
fetchToken = (username, password) => {
  let uri = 'http://localhost:4000/';
  let token = undefined;

  fetch(uri + 'api/login?user_params[username]=' + username +
        '&user_params[password]=' + password,
        {
          method: 'post'
        }
  ).then(
    function(response) {
      return response.text();
    }
  ).then(
    function(text) {
      token = JSON.parse(text).data.token;
    }
  );

  return token;
};
```

Fetch a Phoenix token from the JSON API using the `api/token GET` call.
```javascript
fetchPhoenixToken = (username, password) => {
  let uri = 'http://localhost:4000/';

  // fetchToken() is from our previous example above
  let token = fetchToken(username, password);
  let phoenixToken = undefined;

  let headers = new Headers();
  headers.append('Authorization',
                 'Token token="' +
                 token + '"');

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
      phoenixToken = JSON.parse(text).token;
    }
  );

  return phoenixToken;
};
```

With that Phoenix token, we're almost ready to connect to the socket. But first we need to ensure that we've included the `phoenix-socket` dependency. We can either call `npm install --save phoenix-socket` from the command line, or add it directly in our `package.json`:
```json
"dependencies": {
  "phoenix-socket": "^1.2.3"
}
```

Back in our app, we can finally get goting. Import `Socket` from our `phoenix-socket` dependency. We can then instantiate a `Socket` and join a channel. Note that we passed a function to the optional `logger` parameter when creating our `socket`, which will allow us to track all communication between our app and the server (i.e. `receive: ok spade:11 phx_reply (1) Object {status: "ok", response: Object}`). That's handy during development, but remember to remove for production.
```javascript
import { Socket } from 'phoenix-socket';

joinChannel = (userId, phoenixToken) => {
  socket = new Socket('/socket', {
    params: {token: phoenixToken},
    logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data); }
  });

  let channel = socket.channel('spade:' + userId);

  channel.join()
    .receive('ok', resp => {
      // Do something with data
    })
    .receive('error', resp => {
      console.log('Failed to join spade channel', resp);
    });
}
```

And we're in! To view all the API commands at your disposal, visit the [JSON API docs](https://github.com/davelively14/flatfoot/blob/master/JSON_api.md) and [SpadeChannel docs](https://github.com/davelively14/flatfoot/blob/master/spade_channel.md).
