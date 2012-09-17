
every 1.hour do
	runner 'Vacancy.tweet_about_new_vacancies'
end

every 1.hour do
	runner 'Vacancy.notify_about_not_approved_vacancies'
end