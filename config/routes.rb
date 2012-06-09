Appletunity::Application.routes.draw do
	resource :vacancies
  root :to => 'vacancies#index'
end
