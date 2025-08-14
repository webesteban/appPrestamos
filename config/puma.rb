workers Integer(ENV.fetch("WEB_CONCURRENCY", 2))
threads_count = Integer(ENV.fetch("RAILS_MAX_THREADS", 5))
threads threads_count, threads_count
preload_app!

directory "/var/www/app/current"
bind "unix:///var/www/app/shared/tmp/sockets/puma.sock"
pidfile "/var/www/app/shared/tmp/pids/puma.pid"
stdout_redirect "/var/www/app/shared/log/puma.stdout.log", "/var/www/app/shared/log/puma.stderr.log", true

environment ENV.fetch("RAILS_ENV", "production")
plugin :tmp_restart