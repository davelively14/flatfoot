# Flatfoot
[![Build Status](https://travis-ci.org/davelively14/flatfoot.svg?branch=master)](https://travis-ci.org/davelively14/flatfoot)

Monitors and reports if someone you are tracking is being bullied online.

## Table of Contents

* [Creating a user account](#new-account)
* [Logging in](#login)
* [Getting a socket token](#get-token)
* [User API](#user-api)
  * [Index](#user-index) | [Show](#user-show) | [Update](#user-update) | [Delete](#user-delete)
* [NotificationRecord](#notification-record)
  * [Create](#notification-record-create) | [Index](#notification-record-index) | [Show](#notification-record-show)  | [Update](#notification-record-update) | [Delete](#notification-record-delete)
* [Settings](#settings)
  * [Create](#settings-create) | [Show](#settings-show) | [Update](#settings-update)
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

Returb body:
```json
{
    "data": {
        "token": "eWE0aEx2eVpGTTBYeHlqWnV1VnZSUT09"
    }
}
```

## <a name="get-token"></a>Getting a socket token

With a valid authentication token, will return a Phoenix token that can be used to connect to a channel. Takes no parameters. Authorziation token is required.

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
            "email": "connor.runolfsson@gmail.com"
        },
        {
            "username": "sabina2065",
            "id": 2,
            "email": "dorris2027@gmail.com"
        },
        {
            "username": "jwilkins",
            "id": 3,
            "email": "jwilkins@gmail.com"
        }
    ]
}
```

### <a name="user-show"></a>User#show

Provided a user id in the url and user's information will be returned. Takes no parameters. Does not return password. Authorization token is required.

API path pattern: `api/users/:user_id/`
- Provide `:user_id` (integer)
- Sent via the http `GET` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:
```code
http://localhost:4000/api/users/1
...
Authorization: Token token="eWE0aEx2eVpGTTBYeHlqWnV1VnZSUT09"
```
Return body:
```json
{
    "data": {
        "username": "katarina2027",
        "id": 1,
        "email": "connor.runolfsson@gmail.com"
    }
}
```

### <a name="user-update"></a>User#update

Given a user's id and a list of parameters, update a user's information. Authorization token is required.

Accepted parameters for the `user_params` object.

Name | Required | Type | Notes
--- | :---: | :---: | ---
*username* | no | string | Must be unique and no more than 30 characters.
*email* | no | string | Must be unique and in a valid email format.
*new_password* | no | string | Must be between 6 and 100 characters. MUST be accompanied by `current_password` or it will be ignored.
*current_password* | no | string | Current password. Only required if providing a `new_password`.

API path pattern: `api/users/:user_id?user_params[param]=param_value&user_params[param]=param`
- Provide `:user_id` (integer)
- Provide params to the `user_params` object using the table above. Use the `&` operator to string together additional params.
- Sent via the http `PUT` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:
```code
PUT http://localhost:4000/api/users/1?user_params[username]=kbob12
...
Authorization: Token token="eWE0aEx2eVpGTTBYeHlqWnV1VnZSUT09"
```

Return body:
```json
{
    "data": {
        "username": "kbob12",
        "id": 1,
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

## <a name="settings"></a>Settings API

### <a name="settings-create"></a>Settings#create

Given a list of parameters, it will create settings for the current user. Only one settings may exist for any given user. You will receive an error if you attempt to create a second. Authorization token required.

Accepted parameters for the `params` object.

Name | Required | Type | Notes
--- | :---: | :---: | ---
*global_threshold* | no | string | A number from 0 - 100 that is used as the default threshold for notifications.

API path pattern: `api/settings?params[param]=param_value&params[param]=param`
- Provide params to the `params` object using the table above. Use the `&` operator to string together additional params.
- Sent via the http `POST` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:
```code
POST http://localhost:4000/api/settings?params[global_threshold]=50
...
Authorization: Token token="L2ZmeHJHNzlrSC9sOENnMFcwdjQ4dz09"
```

Return body:
```json
{
    "data": {
        "user_id": 12,
        "id": 12,
        "global_threshold": 50
    }
}
```

### <a name="settings-show"></a>Settings#show

Will return the settings data for the current user. Takes no parameters. Authorization token is required.

API path pattern: `api/settings`
- Sent via the http `GET` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:
```code
GET http://localhost:4000/api/settings
...
Authorization: Token token="dzJ0Mmd4R2tpcnhwZXRkTTZzQXE3QT09"
```

Result body:
```json
{
    "data": {
        "user_id": 12,
        "id": 12,
        "global_threshold": 50
    }
}
```

### <a name="settings-update"></a>Settings#update

Given a list of parameters, update a user's information. Authorization token is required.

Accepted parameters for the `params` object.

Name | Required | Type | Notes
--- | :---: | :---: | ---
*global_threshold* | no | string | A number from 0 - 100 that is used as the default threshold for notifications.

API path pattern: `api/settings?params[param]=param_value&params[param]=param`
- Provide params to the `params` object using the table above. Use the `&` operator to string together additional params.
- Sent via the http `PUT` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:
```code
PUT http://localhost:4000/api/settings?params[global_threshold]=25
...
Authorization: Token token="dzJ0Mmd4R2tpcnhwZXRkTTZzQXE3QT09"
```

Result body:
```json
{
    "data": {
        "user_id": 12,
        "id": 12,
        "global_threshold": 25
    }
}
```

## <a name="blackout-option"></a>Blackout Option API

### <a name="blackout-option-create"></a>Blackout Option#create

Given a list of parameters, it will create a blackout option for a given settings. Authorization token required.

Accepted parameters for the `params` object.

Name | Required | Type | Notes
--- | :---: | :---: | ---
*start* | yes | Ecto.Time | Must be a valid time format. View the [Ecto docs](https://hexdocs.pm/ecto/Ecto.DateTime.html#cast/1) to view accepted formats.
*stop* | yes | Ecto.Time | Must be a valid time format. View the [Ecto docs](https://hexdocs.pm/ecto/Ecto.DateTime.html#cast/1) to view accepted formats.
*settings_id* | yes | integer | The `:id` for your settings.
*threshold* | no | integer | Sets minimum threshold for notification from 1-100. Default is 100.
*exclude* | no | string | Not yet implemented. Will eventually take a string interpretation of a list for which days to exclude. Will default to none. May depreciate in favor a of an exclusion table.

API path pattern: `api/blackout_options?params[param]=param_value&params[param]=param`
- Provide params to the `params` object using the table above. Use the `&` operator to string together additional params.
- Sent via the http `POST` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:
```code
POST http://localhost:4000/api/blackout_options?params[start]=18:00:00&params[stop]=06:00:00&params[settings_id]=12
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
        "settings_id": 12,
        "id": 76,
        "exclude": null
    }
}
```

### <a name="blackout-option-index"></a>Blackout Option#index

Returns all blackout_options for a given settings as passed via the `settings_id` parameter. Authorization token is required.

Name | Required | Type | Notes
--- | :---: | :---: | ---
*settings_id* | yes | integer | The `:id` for your settings.

API path pattern: `api/blackout_options?settings_id=:id`
- Sent via the http `GET` method.
- Include authorization token for a user's session in header.

##### Example:

HTTP call with authorization header:
```code
GET http://localhost:4000/api/blackout_options?settings_id=12
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
            "settings_id": 12,
            "id": 76,
            "exclude": null
        },
        {
            "threshold": 100,
            "stop": "09:00:00",
            "start": "08:00:00",
            "settings_id": 12,
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
        "settings_id": 12,
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
        "settings_id": 12,
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
