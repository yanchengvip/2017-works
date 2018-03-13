# config valid only for current version of Capistrano
lock "3.8.1"
set :rails_env, :production
set :application, "card_game"
set :repo_url, "github.com/card_game.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/data/www/card_game"
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
set :linked_dirs, %w{ log tmp/pids  tmp/sockets vendor/bundle public/uploads }
set :linked_files, %w{config/database.yml config/secrets.yml config/fastdfs.yml config/system_config.yml config/my_alipay.yml config/oneapm.yml config/unicorn/production.rb}
# set :linked_files, %w{config/database.yml config/secrets.yml }
# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :sidekiq_config, "/data/www/card_game/current/config/sidekiq.yml"

# Default value for keep_releases is 5
set :keep_releases, 100
after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:legacy_restart'
    # invoke 'sidekiq:restart'
     Rake::Task["sidekiq:restart"].reenable
  end

end


namespace :show do
  task :log do
    on roles(:app) do
      execute "tail -f #{deploy_to}/shared/log/#{fetch(:rails_env)}.log"
    end
  end
end
