#!/usr/bin/env bash

PLUGIN_ROOT="$PWD"

RUBY_VERSION=$(cat "$PLUGIN_ROOT/.ruby-version" | cut -d '.' -f 1,2)
DOCKER_IMAGE="ruby:$RUBY_VERSION"
BUNDLE_PATH="/app/vendor/bundle"

function setup() {
  docker run --rm \
    -e "BUNDLE_PATH=$BUNDLE_PATH" \
    -v "$PLUGIN_ROOT/":/app \
    -w /app \
    "$DOCKER_IMAGE" \
    bundle install
}

function set_envs() {
  GITHUB_REPO=$(dokku config:get "$APP" GITHUB_REPO || echo)
  GITHUB_TOKEN=$(dokku config:get "$APP" GITHUB_TOKEN || echo)
  GIT_REV=$(dokku config:get "$APP" GIT_REV || echo "$GIT_REV")
  ENVIRONMENT=$(
    dokku config:get "$APP" GITHUB_ENV ||
    dokku config:get "$APP" RAILS_ENV ||
    dokku config:get "$APP" RACK_ENV ||
    echo 'production'
  )
}

function docker_run() {
  docker run --rm \
    -e "BUNDLE_PATH=$BUNDLE_PATH" \
    -e "GITHUB_REPO=$GITHUB_REPO" \
    -e "GITHUB_TOKEN=$GITHUB_TOKEN" \
    -e "GIT_REV=$GIT_REV" \
    -e "ENVIRONMENT=$ENVIRONMENT" \
    -v "$PLUGIN_ROOT/":/app \
    -w /app \
    "$DOCKER_IMAGE" \
    bundle exec ruby lib/github.rb "$@"
}
