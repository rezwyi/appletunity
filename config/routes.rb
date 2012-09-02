Appletunity::Application.routes.draw do
  devise_for :admins

  devise_scope :admin do
    post 'sessions/admin' => 'devise/sessions#create'
  end 

  resources :vacancies

  namespace :administration do
    resources :admins
    resources :vacancies
    resources :occupations
  end

  match '/:id' => 'high_voltage/pages#show', :as => :static, :via => :get
  
  root :to => 'vacancies#index'
end
