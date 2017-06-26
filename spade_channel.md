# Flatfoot
[![Build Status](https://travis-ci.org/davelively14/flatfoot.svg?branch=master)](https://travis-ci.org/davelively14/flatfoot)

Monitors and reports if someone you are tracking is being bullied online.

## Table of Contents

* [Joining a channel](#join)
* [get_user](#get-user)
* [get_ward](#get-ward)
* [get_ward_account_results](#get-ward-account-results)

### <a name="join"></a>Joining a channel

In order to join a channel, one must first instantiate a Phoenix `Socket` with a valid [Phoenix Token](https://github.com/davelively14/flatfoot/blob/master/JSON_api.md#get-token) and then set the channel.

To instantiate a Phoenix `Socket`, import the `Socket` from the `phoenix-socket` dependency:

```javascript
import { Socket } from 'phoenix-socket';

socket = new Socket('ws://localhost:4000/socket', {
  params: {token: phoenixToken},
  logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data); }
});
```

With your new `socket`, use it's `channel` method to create the channel you intend to join. Use the name `spade:1`, where 1 is the user's id.

```javascript
let channel = socket.channel('spade:' + userId);
```

With `channel` in hand, we can now finally join:

```javascript
channel.join()
  .receive('ok', resp => {
    // Do something with resp data
  })
  .receive('error', resp => {
    console.log('Failed to join spade channel', resp);
  });
```

The `join` will synchronously return a user and all of it's associated ward and ward_accounts.

That `channel` object is the key to interacting with the rest of the API. You will use it to push commands and set listeners for responses.

##### Example:

HTTP call with authorization header:
```javascript
import { Socket } from 'phoenix-socket';

joinChannel = (userId, phoenixToken) => {
  let socketUri = 'ws://localhost:4000';

  socket = new Socket(socketUri + '/socket', {
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

Returns:
```javascript
('ok', response_body)
```

Response body:
```javascript
{
  email: "joe@gmail.com",
  global_threshold: 0,
  id: 11,
  username: "joe",
  wards: [
    {
      active: false,
      id: 41,
      name: "Gabriel Kuhlman",
      relationship: "sister",
      user_id: 11,
      ward_accounts: [
        {
          backend_module: "Elixir.Flatfoot.Archer.Backend.Twitter",
          handle: "@genesis_o'connell",
          id: 51,
          last_msg: null,
          network: "Twitter",
          ward_id: 41
        }
      ]
    },
    {
      "active": true,
      id: 42,
      name: "John Smith",
      relationship: "mother",
      user_id: 11,
      ward_accounts: [
        {
          backend_module: "Elixir.Flatfoot.Archer.Backend.Twitter",
          handle: "@bob",
          id: 73,
          last_msg: null,
          network: "Twitter",
          ward_id: 42
        }
      ]
    }
  ],
  watchlists: []
}
```

### <a name="get-user"></a>get_user

On call, will return user data for the currently logged in user. Takes no parameters. Returns a user object via channel broadcast.

##### Example:

Call:

```javascript
channel.push('get_user', {});
```

Asynchronous response message:
```javascript
('user_data', response_body)
```

Response body:
```javascript
{
  id: 13,
  email: 'jon@gmail.com',
  username: 'realjon',
  global_threshold: 0,
  watchlists: undefined,
  wards: [
    {
      id: 1231,
      name: 'Adam Smith',
      relationship: 'son',
      active: true,
      user_id: 13,
      ward_accounts: [
        {
          id: 324324,
          ward_id: 1231,
          handle: '@realAdam',
          last_msg: '1238489243852',
          network: 'Twitter',
          backend_module: 'Elixir.Flatfoot.Archer.Backend.Twitter'
        }
      ]
    }
  ]
}
```

### <a name="get-ward"></a>get_ward

Given a ward id as a passed parameter, will return a ward and it's associated ward_accounts via channel broadcast.

Javascript call pattern:
```javascript
channel.push('get_ward', params_object)
```

Accepted parameters for the `params_object`:

Name | Required | Type | Notes
--- | :---: | :---: | ---
*ward_id* | yes | integer | Valid ward id

Asynchronous return pattern:
```javascript
('ward_wardId_data', ward_object)
```

##### Example:

Call:

```javascript
channel.push('get_ward', {ward_id: 12});
```

Asynchronous response:
```javascript
('user_data', {
  id: 13,
  email: 'jon@gmail.com',
  username: 'realjon',
  global_threshold: 0,
  watchlists: undefined,
  wards: [
    {
      id: 1231,
      name: 'Adam Smith',
      relationship: 'son',
      active: true,
      user_id: 13,
      ward_accounts: [
        {
          id: 324324,
          ward_id: 1231,
          handle: '@realAdam',
          last_msg: '1238489243852',
          network: 'Twitter',
          backend_module: 'Elixir.Flatfoot.Archer.Backend.Twitter'
        }
      ]
    }
  ]
})
```
