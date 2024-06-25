# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.19.0'

set :application, 'thape_forum'
set :repo_url, 'git@git.thape.com.cn:rails/homeland.git'

# Default branch is :master
set :branch, 'thape_forum'

# Default deploy_to directory is /var/www/thape_forum
# set :deploy_to, "/var/www/thape_forum"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, *%w[.env.local puma.rb config/database.yml config/secrets.yml config/redis.yml]

# Default value for linked_dirs is []
append :linked_dirs, *%w[log tmp/pids tmp/cache tmp/sockets public/avatar public/uploads node_modules storage]

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

set :rbenv_type, :user
set :rbenv_ruby, '3.1.4'

set :puma_init_active_record, true
set :puma_phased_restart, true
