module.exports = {
    "env": {
        "node": true,
        "es6": true,
        "browser": true,
        "jasmine": true
    },
    "extends": [
      "eslint:recommended"
    ],
    "plugins": [
      "jasmine"
    ],
    "parserOptions": {
        "sourceType": "module",
        "ecmaFeatures": {
          "jsx": true
        }
    },
    "rules": {
        "indent": [
            "error",
            2,
            {"SwitchCase": 1}
        ],
        "linebreak-style": [
            "error",
            "unix"
        ],
        "quotes": [
            "error",
            "single"
        ],
        "semi": [
            "error",
            "always"
        ],
        "no-console":0,
        "no-unused-vars": ["error", {"argsIgnorePattern": "^_"}]
    }
};
