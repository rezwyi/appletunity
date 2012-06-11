Appletunity::Application.routes.draw do
	resources :vacancies
	match '/:id' => 'high_voltage/pages#show', :as => :static, :via => :get
  root :to => 'vacancies#index'
end
