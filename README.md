# Flatfoot

Monitors and reports if someone you are tracking is being bullied online.

## Session Tokens

In order to secure access, you'll need a token. You can have multiple active tokens per User. This allows a user to manage their logged in status per device (i.e. logging out on your laptop won't destroy the session token you're using on your phone). In order to get a token, the user must create an account or login. Note that every login generates an additional token. While there currently is no limit to number of sessions, but in a later version there will be a max of 10 tokens per user and sessions that remain inactive for 30 days will be deactivated.

## Creating a user account:

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

## Logging in:

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

## User#Index:

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

## User#show

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

## User#update

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

## User#delete

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
