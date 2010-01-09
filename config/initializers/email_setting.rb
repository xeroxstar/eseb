APP_CONFIG = YAML::load(ERB.new((IO.read("#{RAILS_ROOT}/config/settings.yml"))).result)
require 'smtp_tls'
ActionMailer::Base.smtp_settings =  APP_CONFIG[Rails.env].symbolize_keys
#puts "email configuration #{ APP_CONFIG[Rails.env].symbolize_keys.inspect}"