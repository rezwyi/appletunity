# Overrides standart runner to use exact version of ruby
job_type :runner, "rvm use :ruby && cd :path && script/rails runner -e :environment ':task' :output"

every 1.minute do
  command 'redis_server /etc/redis.conf'
end
