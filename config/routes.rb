Appletunity::Application.routes.draw do
	resources :vacancies
  root :to => 'vacancies#index'
end
