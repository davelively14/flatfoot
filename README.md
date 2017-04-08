# Flatfoot

Monitors and reports if someone you are tracking is being bullied online.

## TOC

- [Creating a user account](#new-account)
- [Logging in](#login)
- [User API](#user-api)
 - [Index](#user-index)
 - [Show](#user-show)
 - [Update](#user-update)
 - [Delete](#user-delete)
- [NotificationRecord](#notification-record)
 - [Create](#notification-record-create)
 - [Index](#notification-record-index)
 - [Show](#notification-record-show)
 - [Update](#notification-record-update)
 - [Delete](#notification-record-delete)


## Session Tokens

In order to secure access, you'll need a token. You can have multiple active tokens per User. This allows a user to manage their logged in status per device (i.e. logging out on your laptop won't destroy the session token you're using on your phone). In order to get a token, the user must create an account or login. Note that every login generates an additional token. While there currently is no limit to number of sessions, but in a later version there will be a max of 10 tokens per user and sessions that remain inactive for 30 days will be deactivated.

## <a name="new-account"></a>Creating a user account:

Send this via `POST`:
```
http://localhost:4000/api/new_user?user_params[username]=jwilkins&user_params[password]=password&user_params[email]=jwilkins@gmail.com
```

Returns this:
```json
{
    "data": {
        "token": "eWE0aEx2eVpGTTBYeHlqWnV1VnZSUT09"
    }
}
```

## <a name="login"></a>Logging in:

Returns a token that can be used to authorize.

Run the server and send this via `POST`:
```
http://localhost:4000/api/login?user_params[username]=dlively&user_params[password]=password
```

Returns this:
```json
{
    "data": {
        "token": "eWE0aEx2eVpGTTBYeHlqWnV1VnZSUT09"
    }
}
```

## <a name="user-api"></a>User API

### <a name="user-index"></a>User#Index:

Returns all users.

Get all users by calling `GET` with this this address:
```
http://localhost:4000/api/users
```

Ensure to include authorization in Headers, like this:
```
Authorization: Token token="eWE0aEx2eVpGTTBYeHlqWnV1VnZSUT09"
```

Will return this:

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
            "id": 12,
            "email": "jwilkins@gmail.com"
        }
    ]
}
```

### <a name="user-show"></a>User#show

Return only one user.

Get user by calling `GET` with this address, where `:id` is the id of the user.
```
http://localhost:4000/api/users/:id
```

Ensure to include authorization in Headers, like this:
```
Authorization: Token token="eWE0aEx2eVpGTTBYeHlqWnV1VnZSUT09"
```

Returns this:

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

Update a user's information.

Use this call to `PUT`:
```
http://localhost:4000/api/users/1?user_params[username]=kbob12
```

Ensure to include authorization in Headers, like this:
```
Authorization: Token token="eWE0aEx2eVpGTTBYeHlqWnV1VnZSUT09"
```

Returns this:
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

Deletes the given user.

Use this call with `DELETE`:
```
http://localhost:4000/api/users/1
```

Ensure to include authorization in Headers, like this:
```
Authorization: Token token="eWE0aEx2eVpGTTBYeHlqWnV1VnZSUT09"
```

Will not return any content, only a `204` status.

## <a name="notification-record"></a>Notification Record API

### <a name="notification-record-create"></a>NotificationRecord#create

Creates a notification record for the current user.

Use this call to a `POST`:
```
http://localhost:4000/api/notification_records?params[nickname]=dad&params[email]=dj@gmail.com&params[role]=family&params[threshold]=0
```

Ensure to include authorization in the Headers, like this:
```
Authorization: Token token="L2ZmeHJHNzlrSC9sOENnMFcwdjQ4dz09"
```

Returns this:
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

Returns a list of all notification records for the current user as indicated by the token.

Use this call with `GET`:
```
http://localhost:4000/api/notification_records
```

Ensure to include authorization in the Headers, like this:
```
Authorization: Token token="UU5NcHlhU1Zra0lzcFlFUHZxTXVxZz09"
```

Returns this:
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

Returns a single notification record when passed its id.

Use this call with `GET`:

```
http://localhost:4000/api/notification_records/76
```

Ensure to include the authorization token in the Headers:
```
Authorization: Token token="L2ZmeHJHNzlrSC9sOENnMFcwdjQ4dz09"
```

Returns this:
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

Update a notification record by passing in the parameters you want to change. Returns the updated notification record.

Use this call with `PUT`:
```
http://localhost:4000/api/notification_records/76?params[email]=acdc@gmail.com
```

Ensure to include the authorization token in the Headers:
```
Authorization: Token token="L2ZmeHJHNzlrSC9sOENnMFcwdjQ4dz09"
```

Returns this:
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

Remove a notification record from the database. Does not return any data.

Use this call with `DELETE`:
```
http://localhost:4000/api/notification_records/76
```

Ensure to include the authorization token in the Headers:
```
Authorization: Token token="L2ZmeHJHNzlrSC9sOENnMFcwdjQ4dz09"
```

Will not return any content, only a `204` status.
