# Flatfoot

Monitors and reports if someone you are tracking is being bullied online.

## Creating a user account:



## Logging in:

Run the server and send this:
`http://localhost:4000/api/login?user_params[username]=dlively&user_params[password]=password`

```json
{
    "data": {
        "token": "NmlaQ2VQMzVGM0IxM3hQTCtiQ0NIUT09"
    }
}
```

Use that token for any request
