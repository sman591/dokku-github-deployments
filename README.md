# dokku-github-deployments

Send the status of deployments back to GitHub via the [GitHub Deployments API](https://developer.github.com/v3/repos/deployments/).

## Installation

1. Install the plugin

```
$ dokku plugin:install https://github.com/sman591/dokku-github-deployments.git
```

2. Set the necessary config for each app

```
$ dokku config:set $APP GITHUB_TOKEN=my_github_token
$ dokku config:set $APP GITHUB_REPO=my_user/my_repo
```

If the environment is different than `production`, specify it:

```
$ dokku config:set $APP GITHUB_ENV=my_environment
```
