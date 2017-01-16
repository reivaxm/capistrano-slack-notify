require 'json'
require 'net/http'
module Capistrano
  module SlackNotify
    # HTTPS slack submitter
    module Submitter
      HEX_COLORS = {
        grey: '#CCCCCC',
        red: '#BB0000',
        green: '#7CD197',
        blue: '#103FFB'
      }.freeze

      def post_to_channel(attrs)
        return false if attrs.nil?
        attrs = if attrs.is_a? Hash
                  keys_to_string(attrs)
                else
                  {
                    'text' => attrs.to_s,
                    'color' => :grey
                  }
                end
        if use_color? && HEX_COLORS.keys.include?(attrs['colors'])
          call_slack_api(attachment_payload(attrs['color'], attrs['text']))
        else
          call_slack_api(regular_payload(attrs['text']))
        end
      end

      def call_slack_api(payload)
        uri = URI.parse(slack_webhook_url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        request = Net::HTTP::Post.new(uri.request_uri)
        request.set_form_data(payload: payload)
        resp = http.request(request)
        if resp.code !~ /2\d\d/
          write("Slack response: #{resp.body}", :error)
        else
          write("Slack notifyed on #{slack_channel}", :info)
        end
      rescue SocketError => e
        puts "#{e.message} or slack may be down"
      end

      def regular_payload(announcement)
        {
          'channel'    => slack_channel,
          'username'   => slack_username,
          'text'       => announcement,
          'icon_emoji' => slack_emoji,
          'mrkdwn'     => true
        }.to_json
      end

      def attachment_payload(color, announcement)
        {
          'channel'     => slack_channel,
          'username'    => slack_username,
          'icon_emoji'  => slack_emoji,
          'attachments' => [{
            'fallback'  => announcement,
            'text'      => announcement,
            'color'     => HEX_COLORS[color],
            'mrkdwn_in' => %w(text)
          }]
        }.to_json
      end

      private

      def keys_to_string(hash) # Run without rails
        Hash[hash.map do |k, v|
          [k.to_s, v]
        end]
      end
    end
  end
end
