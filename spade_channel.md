# Flatfoot
[![Build Status](https://travis-ci.org/davelively14/flatfoot.svg?branch=master)](https://travis-ci.org/davelively14/flatfoot)

Monitors and reports if someone you are tracking is being bullied online.

## Table of Contents

* [Joining a channel](#join)
* [get_user](#get-user)
* [get_ward_account_results](#get-ward-account-results)
* [get_ward_results_for_user](#get-ward-results-for-user)
* [fetch_new_ward_results](#fetch-new-ward-results)
* [fetch_backends](#fetch-backends)
* [Ward API](#ward-api)
  * [get_ward](#get-ward) | [create_ward](#create-ward) | [delete_ward](#delete-ward) | [update_ward](#update-ward)
* [WardAccount API](#ward-account-api)
  * [create_ward_account](#create-ward-account) | [delete_ward_account](#delete-ward-account) | [update_ward_account](#update-ward-account)
* [WardResult API](#ward-result-api)
  * [clear_ward_result](#clear-ward-result) | [clear_ward_results](#clear-ward-results)

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

Given a ward id, app will asynchronously return a ward and it's associated ward_accounts via channel broadcast.

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
  id: 12,
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
      user_id: 12,
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

### <a name="get-ward-account-results"></a>get_ward_account_results

Given a ward_account id, app will asynchronously return stored results for a given ward_account. Provide optional `as_of` parameter to return results only after a given date.

Javascript call pattern:
```javascript
channel.push('get_ward_account_results', params_object)
```

Accepted parameters for the `params_object`:

Name | Required | Type | Notes
--- | :---: | :---: | ---
*ward_account_id* | yes | integer | Valid ward_account_id
*as_of* | no | string | ISO style date (YYYY-MM-DD). Error on any other format.

Asynchronous return pattern:
```javascript
('ward_wardAccountId_results', ward_results_object)
```

##### Example:

Call:

```javascript
channel.push('get_ward_account_results', {ward_account_id: 32780, as_of: '2017-05-01'});
```

Asynchronous response:
```javascript
('ward_account_32780_results', {ward_results: [
  {
    id: 56432,
    backend_id: 35159,
    from: "oral.nolan",
    msg_id: "1975",
    msg_text: "This above all: to thine own self be true.",
    rating: 66,
    timestamp: "2017-06-26T01:15:25.610577",
    ward_account_id: 32780
  },
  {
    id: 56431,
    backend_id: 35159,
    from: "raoul_gerhold",
    msg_id: "1350",
    msg_text: "The play 's the thing wherein I'll catch the conscience of the king.",
    rating: 80, timestamp: "2017-06-26T01:15:25.607697",
    ward_account_id: 32780
  }
]})
```

### <a name="get-ward-results-for-user"></a>get_ward_results_for_user

Given a valid session token, app will asynchronously return stored results for that user. Provide optional `as_of` parameter to return results only after a given date.

Javascript call pattern:
```javascript
channel.push('get_ward_results_for_user', params_object)
```

Accepted parameters for the `params_object`:

Name | Required | Type | Notes
--- | :---: | :---: | ---
*token* | yes | string | Valid [session token](https://github.com/davelively14/flatfoot/blob/master/JSON_api.md#get-token)
*as_of* | no | string | ISO style date (YYYY-MM-DD). Error on any other format.

Asynchronous return pattern:
```javascript
('user_ward_results', ward_results_object)
```

##### Example:

Call:

```javascript
channel.push('get_ward_results_for_user', {token: "aDNvZitlK3diYXR6SUx0Z0V4aDFOdz09", as_of: '2017-05-01'});
```

Asynchronous response:
```javascript
('user_ward_results', {ward_results: [
  {
    id: 56432,
    backend_id: 35159,
    from: "oral.nolan",
    msg_id: "1975",
    msg_text: "This above all: to thine own self be true.",
    rating: 66,
    timestamp: "2017-06-26T01:15:25.610577",
    ward_account_id: 32780
  },
  {
    id: 56431,
    backend_id: 35159,
    from: "raoul_gerhold",
    msg_id: "1350",
    msg_text: "The play 's the thing wherein I'll catch the conscience of the king.",
    rating: 80, timestamp: "2017-06-26T01:15:25.607697",
    ward_account_id: 32780
  }
]})
```

### <a name="fetch-new-ward-results"></a>fetch_new_ward_results

Given a valid ward_id, app will fetch new results for all associated ward_accounts and asynchronously return those results.

Javascript call pattern:
```javascript
channel.push('fetch_new_ward_results', params_object)
```

Accepted parameters for the `params_object`:

Name | Required | Type | Notes
--- | :---: | :---: | ---
*ward_id* | yes | integer | Valid ward_id

Asynchronous return pattern:
```javascript
('new_ward_results', ward_results_object)
```

##### Example:

Call:

```javascript
channel.push('fetch_new_ward_results', {ward_id: 1245});
```

Asynchronous response:
```javascript
('new_ward_results', {ward_results: [
  {
    id: 56432,
    backend_id: 35159,
    from: "oral.nolan",
    msg_id: "1975",
    msg_text: "This above all: to thine own self be true.",
    rating: 66,
    timestamp: "2017-06-26T01:15:25.610577",
    ward_account_id: 32780
  },
  {
    id: 56431,
    backend_id: 35159,
    from: "raoul_gerhold",
    msg_id: "1350",
    msg_text: "The play 's the thing wherein I'll catch the conscience of the king.",
    rating: 80, timestamp: "2017-06-26T01:15:25.607697",
    ward_account_id: 32780
  }
]})
```

### <a name="fetch-backends"></a>fetch_backends

On call, will asynchronously return all of the backends.

Javascript call pattern:
```javascript
channel.push('fetch_backends', {})
```

Asynchronous return pattern:
```javascript
('backends_list', backends_list)
```

##### Example:

Call:

```javascript
channel.push('fetch_backends', {});
```

Asynchronous response:
```javascript
('backends_list', {backends: [
  {
    id: 35363,
    module: "Elixir.Flatfoot.Archer.Twitter",
    name: "Twitter",
    url: "http://twitter.com"
  },
  {
    id: 35365,
    module: "Elixir.Flatfoot.Archer.Facebook",
    name: "Facebook",
    url: "http://facebook.com"
  }
]})
```

## <a name="ward-api"></a>Ward API

### <a name="create-ward"></a>create_ward

With valid parameters, will create a new ward and asynchronously return the new ward data.

Javascript call pattern:
```javascript
channel.push('create_ward', params_object)
```

Accepted parameters for the `params_object`:

Name | Required | Type | Notes
--- | :---: | :---: | ---
*name* | yes | string | Name of the individual being watched over
*relationship* | yes | string | Relationship of the ward to the user
*active* | no | boolean | If false, ward_account will not be monitored. Default: true. Not currently implemented.

Asynchronous return pattern:
```javascript
('new_ward', new_ward)
```

##### Example:

Call:

```javascript
channel.push('create_ward', {
  name: "Bob Williams",
  relationship: "Dad"
});
```

Asynchronous response:
```javascript
('new_ward_results', {
  id: 28131,
  active: true,
  name: "Bob Williams",
  relationship: "Dad",
  user_id: 76683
})
```

### <a name="delete-ward"></a>delete_ward

With a valid ward_id, will delete a ward and asynchronously return that ward.

Javascript call pattern:
```javascript
channel.push('delete_ward', params_object)
```

Accepted parameters for the `params_object`:

Name | Required | Type | Notes
--- | :---: | :---: | ---
*id* | yes | integer | Valid ward id

Asynchronous return pattern:
```javascript
('deleted_ward', deleted_ward)
```

##### Example:

Call:

```javascript
channel.push('delete_ward', {id: 28194});
```

Asynchronous response:
```javascript
('deleted_ward', {
  id: 28194,
  active: true,
  name: "John Smith",
  relationship: "brother",
  user_id: 76752
})
```

### <a name="update-ward"></a>update_ward

With a valid ward id and params, will update the ward and asynchronously return the updated ward.

Javascript call pattern:
```javascript
channel.push('update_ward', {id: id, updated_params: params_object})
```

Accepted parameters for `id`:

Name | Required | Type | Notes
--- | :---: | :---: | ---
*id* | yes | integer | Valid ward id

Accepted parameters for the `params_object`:

Name | Required | Type | Notes
--- | :---: | :---: | ---
*name* | no | string | Name of the individual being watched over
*relationship* | no | string | Relationship of the ward to the user
*active* | no | boolean | If false, ward_account will not be monitored. Default: true. Not currently implemented.

Asynchronous return pattern:
```javascript
('updated_ward', updated_ward)
```

##### Example:

Call:

```javascript
channel.push('updated_ward', {id: 28194, updated_params: {
  active: false,
  name: "Dave Williams",
  relationship: "dad"
}});
```

Asynchronous response:
```javascript
('updated_ward', {
  id: 28194,
  active: false,
  name: "Dave Williams",
  relationship: "dad",
  user_id: 76752
})
```

## <a name="ward-account-api"></a>WardAccount API

### <a name="create-ward-account"></a>create_ward_account

With valid parameters, will create a new ward_account and asynchronously return the newly created ward_account.

Javascript call pattern:
```javascript
channel.push('create_ward_account', params_object)
```

Accepted parameters for the `params_object`:

Name | Required | Type | Notes
--- | :---: | :---: | ---
*handle* | yes | string | The unique handle for the social network
*ward_id* | yes | integer | Valid ward id to which this account will belong
*backend_id* | yes | integer | Valid backend id

Asynchronous return pattern:
```javascript
('new_ward_account', new_ward_account)
```

##### Example:

Call:

```javascript
channel.push('create_ward_account', {
  handle: "@realDave",
  ward_id: 28263,
  backend_id: 24358
});
```

Asynchronous response:
```javascript
('new_ward_account', {
  id: 33258,
  backend_module: "Elixir.Flatfoot.Archer.Backend.Twitter",
  handle: "@realDave",
  last_msg: nil,
  network: "Twitter",
  ward_id: 28263
})
```

### <a name="delete-ward-account"></a>delete_ward_account

With a valid ward_account id, will delete the ward_account and asynchronously return the deleted ward_account.

Javascript call pattern:
```javascript
channel.push('delete_ward_account', params_object)
```

Accepted parameters for the `params_object`:

Name | Required | Type | Notes
--- | :---: | :---: | ---
*id* | yes | integer | Valid ward_account id

Asynchronous return pattern:
```javascript
('deleted_ward_account', deleted_ward_account)
```

##### Example:

Call:

```javascript
channel.push('delete_ward_account', {id: 33258});
```

Asynchronous response:
```javascript
('deleted_ward_account', {
  id: 33258,
  backend_module: "Elixir.Flatfoot.Archer.Backend.Twitter",
  handle: "@realDave",
  last_msg: nil,
  network: "Twitter",
  ward_id: 28263
})
```

### <a name="update-ward-account"></a>update_ward_account

With a valid ward_account id and params, will update a ward_account and asynchronously return the updated ward_account.

Javascript call pattern:
```javascript
channel.push('update_ward_account', {id: id, updated_params: params_object})
```

Accepted parameters for `id`:

Name | Required | Type | Notes
--- | :---: | :---: | ---
*id* | yes | integer | Valid ward_account id

Accepted parameters for the `params_object`:

Name | Required | Type | Notes
--- | :---: | :---: | ---
*handle* | no | string | The unique handle for the social network
*backend_id* | no | integer | Valid backend id

Asynchronous return pattern:
```javascript
('updated_ward_account', updated_ward_account)
```

##### Example:

Call:

```javascript
channel.push('updated_ward_account', {id: 33258, updated_params: {
  handle: "mr.blantons",
  backend_id: 14
}});
```

Asynchronous response:
```javascript
('deleted_ward_account', {
  id: 33258,
  backend_module: "Elixir.Flatfoot.Archer.Backend.Facebook",
  handle: "mr.blantons",
  last_msg: nil,
  network: "Facebook",
  ward_id: 28263
})
```

## <a name="ward-result-api"></a>WardResult API

### <a name="clear-ward-result"></a>clear_ward_result

With a valid ward_result id, will delete a ward_result and asynchronously return the deleted ward_result.

Javascript call pattern:
```javascript
channel.push('clear_ward_result', params_object)
```

Accepted parameters for the `params_object`:

Name | Required | Type | Notes
--- | :---: | :---: | ---
*id* | yes | integer | Valid ward_result id

Asynchronous return pattern:
```javascript
('cleared_ward_result', cleared_ward_result)
```

##### Example:

Call:

```javascript
channel.push('clear_ward_result', {id: 57628});
```

Asynchronous response:
```javascript
('cleared_ward_result', {
  id: 57628,
  backend_id: 35572,
  from: "hellen_conroy",
  msg_id: "1178",
  msg_text: "When sorrows come, they come not single spies, but in battalions.",
  rating: 79,
  timestamp: "2017-06-26T03:19:07.193415",
  ward_account_id: 33362
})
```

### <a name="clear-ward-results"></a>clear_ward_results

With either a valid ward id or ward_account id, the app will delete all associated ward_results and asynchronously return those deleted ward_results.

Javascript call pattern:
```javascript
channel.push('clear_ward_results', params_object)
```

Only accepts one of the following parameters for the `params_object`. *Note:* only supply one of these parameters.

Name | Required | Type | Notes
--- | :---: | :---: | ---
*ward_id* | no | integer | Valid ward id
*ward_account_id* | no | integer | Valid ward account id

Asynchronous return pattern:
```javascript
('cleared_ward_results', cleared_ward_results)
```

##### Example:

Call:

```javascript
channel.push('clear_ward_results', {ward_account_id: 33468});
```

Asynchronous response:
```javascript
('cleared_ward_results', {ward_results:
  [
    {
      backend_id: 35635,
      from: "donna.boyer",
      id: 57849,
      msg_id: "1974",
      msg_text: "Neither a borrower nor a lender be; For loan oft loses both itself and friend, and borrowing dulls the edge of husbandry.",
      rating: 64,
      timestamp: "2017-06-26T03:28:02.762071",
      ward_account_id: 33468
    },
    {
      backend_id: 35635,
      from: "alberto_hansen",
      id: 57850, msg_id: "1165",
      msg_text: "Brevity is the soul of wit.",
      rating: 36,
      timestamp: "2017-06-26T03:28:02.765543",
      ward_account_id: 33468
    }
  ]
})
```
