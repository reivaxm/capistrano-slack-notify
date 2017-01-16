# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/slack_notify/version'

Gem::Specification.new do |spec|
  spec.name          = 'capistrano-slack-notify'
  spec.version       = Capistrano::SlackNotify::VERSION
  spec.date          = '2017-01-16'
  spec.authors       = ['Parker Moore', 'Xavier Mortelette']
  spec.email         = ['parkrmoore@gmail.com', 'reivaxm@epikaf.net']
  spec.summary       = 'Minimalist Capistrano 3 notifier for Slack.'
  spec.description   = %(This gem provide a minimalist slack notifier
                         by the webhook https://api.slack.com/incoming-webhooks.
                         This gem working only with capistrano 3 and later)
  spec.homepage      = 'https://github.com/reivaxm/capistrano-slack-notify'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'capistrano', '~> 3'

  spec.add_development_dependency 'bundler', '~> 1.7'
end
