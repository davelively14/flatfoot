# Flatfoot
[![Build Status](https://travis-ci.org/davelively14/flatfoot.svg?branch=master)](https://travis-ci.org/davelively14/flatfoot)

Monitors and reports if someone you are tracking is being bullied online.

## Table of Contents

* [Creating a user account](#new-account)
* [Logging in](#login)
* [Getting a Phoenix Token](#get-token)
* [User API](#user-api)
  * [Index](#user-index) | [Show](#user-show) | [Update](#user-update) | [Delete](#user-delete) | [Validate User](#user-validate)
* [NotificationRecord](#notification-record)
  * [Create](#notification-record-create) | [Index](#notification-record-index) | [Show](#notification-record-show)  | [Update](#notification-record-update) | [Delete](#notification-record-delete)
* [BlackoutOption API](#blackout-option)
  * [Create](#blackout-option-create) | [Index](#blackout-option-index) | [Show](#blackout-option-show)  | [Update](#blackout-option-update) | [Delete](#blackout-option-delete)

## Session Tokens

In order to secure access, you'll need a token to access most features of the API. You can have multiple active tokens per User. This allows a user to manage their logged in status per device (i.e. logging out on your laptop won't destroy the session token you're using on your phone). In order to get a token, the user must create an account or login. Note that every login generates an additional token. While there currently is no limit to number of sessions, but in a later version there will be a max of 10 tokens per user and sessions that remain inactive for 30 days will be deactivated.

## <a name="new-account"></a>Creating a user account:

Provide basic user information to create an account and receive a session token. No authorization required to access.

Accepted parameters for the `user_params` object:

Name | Required | Type | Notes
--- | :---: | :---: | ---
*username* | yes | string | Must be unique and no more than 30 characters.
*email* | yes | string | Must be unique and in a valid email format.
*password* | yes | string | Must be between 6 and 100 characters. Will be hashed on server.
*global_threshold* | no | integer | Must be between 0 and 100 inclusively. Default is 0.

API path pattern: `api/new_user?user_params[param]=param_value&user_params[param]=param_value...`
- Provide params to the `user_params` object using the table above. Use the `&` operator to string together additional params.
- Sent via the http `POST` method.

##### Example:

HTTP call (no authorization headers required):
```code
POST http://localhost:4000/api/new_user?user_params[username]=jwilkins&user_params[password]=password&user_params[email]=jwilkins@gmail.com
```

Return body:
```json
{
    "data": {
        "token": "eWE0aEx2eVpGTTBYeHlqWnV1VnZSUT09"
    }
}
```

## <a name="login"></a>Logging in:

Provide username and password and receive a session token. No authorization required to access.

Accepted parameters:

Name | Required | Type | Notes
--- | :---: | :---: | ---
*username* | yes | string | Must be unique and no more than 30 characters.
*password* | yes | string | Must be between 6 and 100 characters. Will be hashed when stored on the server.

API path pattern: `api/login?user_params[param]=param&user_params[param]`
- Provide params to the `user_params` object using the table above. Use the `&` operator to string together additional params.
- Sent via the http `POST` method.

##### Example:

HTTP call (no authorization headers required):
```code
POST http://localhost:4000/api/login?user_params[username]=dlively&user_params[password]=password
```

Return body:
```json
{
    "data": {
        "token": "eWE0aEx2eVpGTTBYeHlqWnV1VnZSUT09"
    }
}
```

## <a name="get-token"></a>Getting a Phoenix Token

With a valid authentication token, will return a Phoenix token that can be used to connect to a channel. Takes no parameters. Authorization token is required.

API path pattern: `api/token`
- Sent via the http `GET` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:
```code
GET http://localhost:4000/api/token
...
Authorization: Token token="eWE0aEx2eVpGTTBYeHlqWnV1VnZSUT09"
```

Return body:
```json
{
    "token": "IOPyNTY.g3QAJKLCZAAEZGF0YWELZAAGc2lnbmVkbgYAUv4SWFsB.fmlQX7tWQyxUh6KPC0Eq9tLioTadZd7jiduY5Lf29DE"
}
```

## <a name="user-api"></a>User API

### <a name="user-index"></a>User#index:

Returns all users when called. Currently only available during dev. Takes no parameters. Authorization token is required.

API path pattern: `api/users`
- Sent via the http `GET` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:
```code
GET http://localhost:4000/api/users
...
Authorization: Token token="eWE0aEx2eVpGTTBYeHlqWnV1VnZSUT09"
```

Return body:
```json
{
    "data": [
        {
            "username": "katarina2027",
            "id": 1,
            "global_threshold": 0,
            "email": "connor.runolfsson@gmail.com"
        },
        {
            "username": "sabina2065",
            "id": 2,
            "global_threshold": 0,
            "email": "dorris2027@gmail.com"
        },
        {
            "username": "jwilkins",
            "id": 3,
            "global_threshold": 0,
            "email": "jwilkins@gmail.com"
        }
    ]
}
```

### <a name="user-show"></a>User#show

Provide a session token in the url and user's information will be returned. Takes no parameters. Does not return password. Authorization token is NOT required.

API path pattern: `api/users/token/token=token`
- Provide valid `token` (string) that matches a corresponding session token.
- Sent via the http `GET` method.

##### Example:

HTTP call:
```code
http://localhost:4000/api/users/token?token=VHpnSTFaUU01SExoQkJMRVZXUUgvQT09
```
Return body:
```json
{
    "data": {
        "username": "katarina2027",
        "id": 1,
        "global_threshold": 0,
        "email": "connor.runolfsson@gmail.com"
    }
}
```

### <a name="user-update"></a>User#update

Given a user's token and a list of parameters, update a user's information. Authorization token is required.

Accepted parameters for the `user_params` object.

Name | Required | Type | Notes
--- | :---: | :---: | ---
*username* | no | string | Must be unique and no more than 30 characters.
*email* | no | string | Must be unique and in a valid email format.
*global_threshold* | no | integer | Must be between 0 and 100 inclusively.
*new_password* | no | string | Must be between 6 and 100 characters. MUST be accompanied by `current_password` or it will be ignored.
*current_password* | no | string | Current password. Only required if providing a `new_password`.

API path pattern: `api/users?token=token&user_params[param]=param_value&user_params[param]=param`
- Provide params, separated by the `&` operator:
  - Provide `token` to the `token` parameter (string)
  - Provide params to the `user_params` object using the table above. Use the `&` operator to string together additional params.
- Sent via the http `PUT` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:
```code
PUT http://localhost:4000/api/users?token=eWE0aEx2eVpGTTBYeHlqWnV1VnZSUT09&user_params[username]=kbob12
...
Authorization: Token token="eWE0aEx2eVpGTTBYeHlqWnV1VnZSUT09"
```

Return body:
```json
{
    "data": {
        "username": "kbob12",
        "id": 1,
        "global_threshold": 0,
        "email": "connor.runolfsson@gmail.com"
    }
}
```

### <a name="user-delete"></a>User#delete

Provided a user id in the url, will delete the user's account. Does not return any data. Takes no parameters. Authorization token is required.

API path pattern: `api/users/:user_id`
- Provide `:user_id` (integer)
- Sent via the http `DELETE` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:
```code
DELETE http://localhost:4000/api/users/1
...
Authorization: Token token="eWE0aEx2eVpGTTBYeHlqWnV1VnZSUT09"
```

This function will not return any data, only a `204` status.

### <a name="user-validate"></a>User#validate_user

Provided a username and password, will return a JSON object that indicates if that is an authorized user or not. No sessions are created or updated when run.

Both parameters below are required.

Name | Required | Type | Notes
--- | :---: | :---: | ---
*username* | yes | string | Must match an existing username.
*password* | yes | string | Must match the password for the username.

API path pattern: `api/users/validate?username=username&password=password`
- Provide individual params, separated by the `&` operator:
- Sent via the http `GET` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:
```code
GET http://localhost:4000/api/users/validate?username=dlively&password=password
...
Authorization: Token token="eWE0aEx2eVpGTTBYeHlqWnV1VnZSUT09"
```

Return body on success:
```json
{
    "authorized": true
}
```

Return body with invalid password:
```json
{
    "error": "password was incorrect",
    "authorized": false
}
```

Return body with invalid username:
```json
{
    "error": "username does not exist",
    "authorized": false
}
```

## <a name="notification-record"></a>Notification Record API

### <a name="notification-record-create"></a>NotificationRecord#create

Given a list of parameters, it will create a notification record for the current user. Authorization token required.

Accepted parameters for the `params` object.

Name | Required | Type | Notes
--- | :---: | :---: | ---
*nickname* | yes | string | No more than 40 characters.
*email* | yes | string | Must be in a valid email format.
*role* | no | string | User customized role.
*threshold* | no | integer | Sets minimum threshold for notification from 1-100. Default is 0.

API path pattern: `api/notification_records?params[param]=param_value&params[param]=param`
- Provide params to the `params` object using the table above. Use the `&` operator to string together additional params.
- Sent via the http `POST` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:
```code
http://localhost:4000/api/notification_records?params[nickname]=dad&params[email]=dj@gmail.com&params[role]=family&params[threshold]=0
...
Authorization: Token token="L2ZmeHJHNzlrSC9sOENnMFcwdjQ4dz09"
```

Return body:
```json
{
    "data": {
        "user_id": 11,
        "threshold": 0,
        "role": "family",
        "nickname": "dad",
        "id": 76,
        "email": "dj@gmail.com"
    }
}
```

### <a name="notification-record-index"></a>NotificationRecord#index

Returns a list of all notification records for the current user as indicated by the token. Takes no parameters. Authorization token required.

API path pattern: `api/notification_records`
- Sent via the http `GET` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:
```code
GET http://localhost:4000/api/notification_records
...
Authorization: Token token="UU5NcHlhU1Zra0lzcFlFUHZxTXVxZz09"
```

Return body:
```json
{
    "data": [
        {
            "user_id": 11,
            "threshold": 38,
            "role": "real-time",
            "nickname": "Miss Abdiel Friesen",
            "id": 18,
            "email": "kurtis_blanda@hotmail.com"
        },
        {
            "user_id": 11,
            "threshold": 2,
            "role": "reciprocal",
            "nickname": "Marielle Balistreri",
            "id": 31,
            "email": "maryse1998@hotmail.com"
        },
        {
            "user_id": 11,
            "threshold": 36,
            "role": "human-resource",
            "nickname": "Wiley Gibson",
            "id": 72,
            "email": "benny2077@gmail.com"
        }
    ]
}
```

### <a name="notification-record-show"></a>NotificationRecord#show

Provided a notification record id in the url, will return the record's information. Takes no parameters. Authorization token is required.

API path pattern: `api/users/:notification_record_id`
- Provide `:notification_record_id` (integer)
- Sent via the http `GET` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:
```code
GET http://localhost:4000/api/notification_records/76
...
Authorization: Token token="L2ZmeHJHNzlrSC9sOENnMFcwdjQ4dz09"
```

Return body:
```json
{
    "data": {
        "user_id": 11,
        "threshold": 0,
        "role": "family",
        "nickname": "dad",
        "id": 76,
        "email": "dj@gmail.com"
    }
}
```

### <a name="notification-record-update"></a>NotificationRecord#update

Given a notification record's id and a list of parameters, update a records's information. Authorization token is required.

Accepted parameters for the `params` object.

Name | Required | Type | Notes
--- | :---: | :---: | ---
*username* | no | string | Must be unique and less than 30 characters.
*email* | no | string | Must be unique and in a valid email format.
*new_password* | no | string | Must be between 6 and 100 characters. MUST be accompanied by `current_password` or it will be ignored.
*current_password* | no | string | Current password. Only required if providing a `new_password`.

API path pattern: `api/users/:notification_record_id?params[param]=param_value&params[param]=param`
- Provide `:notification_record_id` (integer)
- Provide params to the `params` object using the table above. Use the `&` operator to string together additional params.
- Sent via the http `PUT` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:
```code
PUT http://localhost:4000/api/notification_records/76?params[email]=acdc@gmail.com
...
Authorization: Token token="L2ZmeHJHNzlrSC9sOENnMFcwdjQ4dz09"
```

Return body:
```json
{
    "data": {
        "user_id": 11,
        "threshold": 0,
        "role": "family",
        "nickname": "dad",
        "id": 76,
        "email": "acdc@gmail.com"
    }
}
```

### <a name="notification-record-delete"></a>NotificationRecord#delete

Provided a notification record id, removes that record from the database. Does not return any data. Takes no parameters. Authorization token is required.

API path pattern: `api/users/:notification_record_id`
- Provide `:notification_record_id` (integer)
- Sent via the http `DELETE` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:

Use this call with `DELETE`:
```code
DELETE http://localhost:4000/api/notification_records/76
...
Authorization: Token token="L2ZmeHJHNzlrSC9sOENnMFcwdjQ4dz09"
```

This function will not return any data, only a `204` status.

## <a name="blackout-option"></a>Blackout Option API

### <a name="blackout-option-create"></a>Blackout Option#create

Given a list of parameters, it will create a blackout option for a given user. Authorization token required.

Accepted parameters for the `params` object.

Name | Required | Type | Notes
--- | :---: | :---: | ---
*start* | yes | Ecto.Time | Must be a valid time format. View the [Ecto docs](https://hexdocs.pm/ecto/Ecto.DateTime.html#cast/1) to view accepted formats.
*stop* | yes | Ecto.Time | Must be a valid time format. View the [Ecto docs](https://hexdocs.pm/ecto/Ecto.DateTime.html#cast/1) to view accepted formats.
*user_id* | yes | integer | The `:id` for your user.
*threshold* | no | integer | Sets minimum threshold for notification from 1-100. Default is 100.
*exclude* | no | string | Not yet implemented. Will eventually take a string interpretation of a list for which days to exclude. Will default to none. May depreciate in favor a of an exclusion table.

API path pattern: `api/blackout_options?params[param]=param_value&params[param]=param`
- Provide params to the `params` object using the table above. Use the `&` operator to string together additional params.
- Sent via the http `POST` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:
```code
POST http://localhost:4000/api/blackout_options?params[start]=18:00:00&params[stop]=06:00:00&params[user_id]=12
...
Authorization: Token token="eWE0aEx2eVpGTTBYeHlqWnV1VnZSUT09"
```

Return body:
```json
{
    "data": {
        "threshold": 100,
        "stop": "06:00:00",
        "start": "18:00:00",
        "user_id": 12,
        "id": 76,
        "exclude": null
    }
}
```

### <a name="blackout-option-index"></a>Blackout Option#index

Returns all blackout_options for a given user as passed via the `user_id` parameter. Authorization token is required.

Name | Required | Type | Notes
--- | :---: | :---: | ---
*user_id* | yes | integer | The `:id` for your user.

API path pattern: `api/blackout_options?user_id=:id`
- Sent via the http `GET` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:
```code
GET http://localhost:4000/api/blackout_options?user_id=12
...
Authorization: Token token="dzJ0Mmd4R2tpcnhwZXRkTTZzQXE3QT09"
```

Return body:
```json
{
    "data": [
        {
            "threshold": 100,
            "stop": "06:00:00",
            "start": "18:00:00",
            "user_id": 12,
            "id": 76,
            "exclude": null
        },
        {
            "threshold": 100,
            "stop": "09:00:00",
            "start": "08:00:00",
            "user_id": 12,
            "id": 77,
            "exclude": null
        }
    ]
}
```

### <a name="blackout-option-show"></a>Blackout Option#show

Provided a blackout option id in the url and the option will be returned. Takes no parameters. Authorization token is required.

API path pattern: `api/blackout_options/:blackout_option_id/`
- Provide `:blackout_option_id` (integer)
- Sent via the http `GET` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:
```code
GET http://localhost:4000/api/blackout_options/76
...
Authorization: Token token="dzJ0Mmd4R2tpcnhwZXRkTTZzQXE3QT09"
```

Return body:
```json
{
    "data": {
        "threshold": 100,
        "stop": "06:00:00",
        "start": "18:00:00",
        "user_id": 12,
        "id": 76,
        "exclude": null
    }
}
```

### <a name="blackout-option-update"></a>Blackout Option#update

Given a blackout option's id and a list of parameters, update an option's information. Authorization token is required.

Accepted parameters for the `params` object.

Name | Required | Type | Notes
--- | :---: | :---: | ---
*start* | no | Ecto.Time | Must be a valid time format. View the [Ecto docs](https://hexdocs.pm/ecto/Ecto.DateTime.html#cast/1) to view accepted formats.
*stop* | no | Ecto.Time | Must be a valid time format. View the [Ecto docs](https://hexdocs.pm/ecto/Ecto.DateTime.html#cast/1) to view accepted formats.
*threshold* | no | integer | Sets minimum threshold for notification from 1-100. Default is 100.
*exclude* | no | string | Not yet implemented. Will eventually take a string interpretation of a list for which days to exclude. Will default to none. May depreciate in favor a of an exclusion table.

API path pattern: `api/blackout_options/:blackout_option_id?params[param]=param_value&params[param]=param`
- Provide params to the `params` object using the table above. Use the `&` operator to string together additional params.
- Sent via the http `PUT` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:
```code
PUT http://localhost:4000/api/blackout_options/76?params[start]=15:30:00
...
Authorization: Token token="eWE0aEx2eVpGTTBYeHlqWnV1VnZSUT09"
```

Return body:
```json
{
    "data": {
        "threshold": 100,
        "stop": "06:00:00",
        "start": "15:30:00",
        "user_id": 12,
        "id": 76,
        "exclude": null
    }
}
```

### <a name="blackout-option-delete"></a>Blackout Option#delete

Provided a blackout option id in the url, will delete the blackout option. Does not return any data. Takes no parameters. Authorization token is required.

API path pattern: `api/blackout_options/:blackout_option_id`
- Provide `:blackout_option_id` (integer)
- Sent via the http `DELETE` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:
```code
DELETE http://localhost:4000/api/blackout_options/76
...
Authorization: Token token="eWE0aEx2eVpGTTBYeHlqWnV1VnZSUT09"
```

This function will not return any data, only a `204` status.
