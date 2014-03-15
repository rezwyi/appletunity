require 'resque/server'

Appletunity::Application.routes.draw do
  resque_constraint = Proc.new { |request| request.env['warden'].authenticate? }
  
  constraints resque_constraint do
    mount Resque::Server.new, at: '/resque', as: :resque
  end
  
  devise_for :admins

  devise_scope :admin do
    post 'sessions/admin' => 'devise/sessions#create'
  end 

  resource :logos, only: :create
  resources :vacancies, except: :delete do
    get 'feed', on: :collection, defaults: {format: 'rss'}
  end

  namespace :administration do
    resources :vacancies, except: :show
    resources :admins
    resources :occupations
  end

  get '/about' => 'pages#about', as: :about_page
  get '/terms' => 'pages#terms', as: :terms_page
  
  root to: 'vacancies#index'
end