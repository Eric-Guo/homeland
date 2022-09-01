# frozen_string_literal: true

set :nginx_use_ssl, false
set :rails_env, 'production'
set :puma_service_unit_name, :puma_thape_forum
set :puma_systemctl_user, :system
set :sidekiq_service_unit_user, :system

server 'thape_homeland', user: 'thape_forum', roles: %w{app db web}
