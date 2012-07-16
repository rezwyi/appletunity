Appletunity::Application.routes.draw do
	get 'login', :to => 'sessions#new'
	get 'logout', :to => 'sessions#destroy'
	get 'admin', :to => 'admin/vacancies#index'
	get 'admin/configuration', :to => 'admin/users#index'
	
	match '/:id' => 'high_voltage/pages#show', :as => :static, :via => :get
	
	resources :vacancies
	resources :sessions

	namespace :admin do
	  resources :vacancies
	  resources :users
	  resources :occupations
	end
  
  root :to => 'vacancies#index'
end
