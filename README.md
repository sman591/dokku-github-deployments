# dokku-github-deployments

Send the status of deployments back to GitHub via the [GitHub Deployments API](https://developer.github.com/v3/repos/deployments/).

* When an app deployment starts, the `in_progress` status will be sent
* When an app deployment finishes, the `success` status will be sent

Whenever a status is sent, it will attempt find an existing deployment matching the given environment and Git SHA. If a deployment isn't found, it will create one.

## Installation

1. Install the plugin

```
$ dokku plugin:install https://github.com/sman591/dokku-github-deployments.git
```

2. Set the necessary config for each app

```
$ dokku config:set --no-restart $APP GITHUB_TOKEN=my_github_token
$ dokku config:set --no-restart $APP GITHUB_REPO=my_user/my_repo
```

If the environment is different than `production`, specify it:

```
$ dokku config:set --no-restart $APP GITHUB_ENV=my_environment
```
