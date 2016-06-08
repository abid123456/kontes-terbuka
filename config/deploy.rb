# config valid only for current version of Capistrano
lock '3.5'

set :application, 'kontes-terbuka'
set :repo_url, 'git@github.com:donjar/kontes-terbuka.git'
set :branch, 'development'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/ktom/kontes-terbuka'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml',
												 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids',
											   'tmp/cache', 'tmp/sockets',
											   'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :ssh_options, { :forward_agent => true, :port => 1729 }
set :use_sudo, false
set :rails_env, "production"

namespace :deploy do

	desc 'Restart application'
	task :restart do
		on roles(:app), in: :sequence, wait: 5 do
			execute :touch, release_path.join('tmp/restart.txt')
		end
	end

	after :publishing, 'deploy:restart'
	after :finishing, 'deploy:cleanup'
end
