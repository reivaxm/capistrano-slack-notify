module Capistrano
  module SlackNotify
    # Capistrano tunning options
    module Configuration
      def use_color?
        fetch(:slack_color, true)
      end

      def slack_webhook_url
        fetch(:slack_webhook_url)
      end

      def slack_channel
        fetch(:slack_room, '#platform')
      end

      def slack_username
        fetch(:slack_username, 'capistrano')
      end

      def slack_emoji
        fetch(:slack_emoji, ':rocket:')
      end

      def slack_app_name
        fetch(:slack_app_name, fetch(:application))
      end

      def deployer
        fetch(
          :deployer,
          ENV['USER'] || ENV['GIT_AUTHOR_NAME'] || `git config user.name`.chomp
        )
      end

      def stage
        fetch(:stage, :production)
      end

      def destination
        fetch(:slack_destination, stage)
      end

      def repository
        fetch(:repository, :origin)
      end

      def branch
        fetch(:branch, :master)
      end

      def rev
        @rev ||= `git ls-remote #{repository} #{branch}`.split(' ').first
      end

      def deploy_target
        [slack_app_name, branch].join('/') + (rev ? " (#{rev[0..5]})" : '')
      end

      private

      def write(message, level = :info)
        logger = SSHKit.config.output

        category = case level
                   when :info
                     Logger::INFO
                   when :error
                     Logger::ERROR
                   else
                     Logger::INFO
                   end

        logger << SSHKit::LogMessage.new(category, message)
      end
    end
  end
end
