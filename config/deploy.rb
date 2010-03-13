#set :stages, %w(staging production)
#set :default_stage, "production"
#require 'capistrano/ext/multistage'
default_run_options[:pty] = true
set :application, "eseb"
set :repository,  "git@github.com:RobDoan/eseb.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
#set :scm_passphrase, "RobdaMAN"
set :user, "robdoan"
set :branch, 'master'
set :ssh_options, { :forward_agent => true }
#set :deploy_via, :remote_cache
set :rails_env, :production

set :deploy_to, '/var/www/eseb'
set :copy_cache, true

role :web, "localhost"                          # Your HTTP server, Apache/etc
role :app, "localhost"                          # This may be the same as your `Web` server
role :db,  "localhost", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  task :copy_database_yml, :roles => :app do
    db_config = "/var/www/#{application}/conf/database.yml"
    run "cp #{db_config} #{release_path}/config/database.yml"
  end
end
