require 'resque/server'

Appletunity::Application.routes.draw do
  resque_constraint = Proc.new { |request| request.env['warden'].authenticate? }
  
  constraints resque_constraint do
    mount Resque::Server.new, :at => '/resque'
  end
  
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

  get '/pages/:id' => 'high_voltage/pages#show', :as => :static
  
  root :to => 'vacancies#index'
end
