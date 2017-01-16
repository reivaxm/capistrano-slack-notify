require 'capistrano'
require 'capistrano/slack_notify/configuration'
require 'capistrano/slack_notify/submitter'

include Capistrano::SlackNotify::Configuration
include Capistrano::SlackNotify::Submitter

namespace :slack do
  desc 'Notify Slack that the deploy has started.'
  task :starting do
    post_to_channel(
      color: :grey,
      text: "#{deployer} is deploying #{deploy_target} to #{destination}"
    )
    set(:start_time, Time.now)
  end

  desc 'Notify Slack that the rollback has completed.'
  task :rolled_back do
    post_to_channel(
      color: :green,
      text: "#{deployer} has rolled back #{deploy_target}"
    )
  end

  desc 'Notify Slack that the deploy has completed successfully.'
  task :finished do
    msg = "#{deployer} deployed #{deploy_target} "
    msg << "to #{destination} *successfully*"

    start_time = fetch(:start_time, nil)
    msg << if !start_time.nil?
             " in #{Time.now.to_i - start_time.to_i} seconds."
           else
             '.'
           end

    post_to_channel(color: :green, text: msg)
  end

  desc 'Notify Slack that the deploy failed.'
  task :failed do
    post_to_channel(
      color: :red,
      text: "#{deployer} *failed* to deploy #{deploy_target} to #{destination}"
    )
  end
end # end namespace :slack
