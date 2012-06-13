Appletunity::Application.routes.draw do
	match 'login', :to => 'sessions#new'
	match '/:id' => 'high_voltage/pages#show', :as => :static, :via => :get
	
	resources :vacancies
	resources :sessions
  
  root :to => 'vacancies#index'
end
