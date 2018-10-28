require 'active_support'
require 'active_support/core_ext'
require 'octokit'

def main
  github = GitHub.new

  command = ARGV[0]
  case command
  when "deploy_status"
    state = ARGV[1]
    if state.blank?
      puts "Usage: github.rb deploy_status STATE"
      puts "       STATE is one of the states from the GitHub deployments API (success, failure, etc)"
      puts "       Will create a deployment if one doesn't already exist"
      exit 1
    end
    github.deploy_status(state)
  else
    puts "Usage: github.rb [deploy_status] (args)"
    exit 1
  end
end

class GitHub
  def client
    @@client ||= Octokit::Client.new(access_token: access_token)
  end

  def deploy_status(state)
    deployment_url = most_recent_deployment[:url]
    deployment_status = client.create_deployment_status(
      deployment_url,
      state,
      {
        description: 'Deploying via Dokku',
        accept: 'application/vnd.github.flash-preview+json',
      }
    )
    puts "Created deployment status: #{deployment_status[:url]}"
  end

  private

  def env(variable)
    ENV[variable].presence || raise("Error: #{variable} not set!")
  end

  def access_token
    env 'GITHUB_TOKEN'
  end

  def repo
    env 'GITHUB_REPO'
  end

  def git_rev
    env 'GIT_REV'
  end

  def environment
    env 'ENVIRONMENT'
  end

  def deployments
    client.deployments(
      repo,
      {
        ref: git_rev,
        environment: environment,
      }
    )
  end

  def create_deployment
    deployment = client.create_deployment(
      repo,
      git_rev,
      {
        auto_merge: false,
        environment: environment,
        required_contexts: [],
        description: 'Deploying via Dokku',
      }
    )
    puts "Created deployment: #{deployment[:url]}"
    return deployment
  end

  def most_recent_deployment
    deployments[0] || create_deployment
  end
end

main
