# Flatfoot

Monitors and reports if someone you are tracking is being bullied online.

## Session Tokens

In order to secure access, you'll need a token. You can have multiple active tokens per User. This allows a user to manage their logged in status per device (i.e. logging out on your laptop won't destroy the session token you're using on your phone). In order to get a token, the user must create an account or login. Note that every login generates an additional token. While there currently is no limit to number of sessions, but in a later version there will be a max of 10 tokens per user and sessions that remain inactive for 30 days will be deactivated.

## Creating a user account:

Run the server and send this via `POST`:
`http://localhost:4000/api/new_user?user_params[username]=jwilkins&user_params[password]=password&user_params[email]=jwilkins@gmail.com`

```json
{
    "data": {
        "username": "jwilkins",
        "id": 12,
        "email": "jwilkins@gmail.com"
    }
}
```

## Logging in:

Run the server and send this via `POST`:
`http://localhost:4000/api/login?user_params[username]=dlively&user_params[password]=password`

```json
{
    "data": {
        "token": "NmlaQ2VQMzVGM0IxM3hQTCtiQ0NIUT09"
    }
}
```
