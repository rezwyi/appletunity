# Overrides standart runner to use exact version of ruby
job_type :runner, "rvm use :ruby && cd :path && script/rails runner -e :environment ':task' :output"

every 1.hour do
	runner 'Vacancy.tweet_about_new_vacancies'
end

every 1.hour do
	runner 'Vacancy.notify_about_not_approved_vacancies'
end