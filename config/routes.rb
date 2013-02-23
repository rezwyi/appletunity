Appletunity::Application.routes.draw do
  devise_for :admins

  devise_scope :admin do
    post 'sessions/admin' => 'devise/sessions#create'
  end 

  resources :vacancies, :except => :delete do
    get 'feed', :on => :collection, :format => :rss
  end

  namespace :administration do
    resources :vacancies do
      get :awaiting_approve, :on => :collection
    end
    resources :admins
    resources :occupations
  end

  match '/:id' => 'high_voltage/pages#show', :as => :static, :via => :get
  
  root :to => 'vacancies#index'
end
