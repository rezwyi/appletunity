require 'spec_helper'

describe 'Application routing' do
  it 'should routes to vacancies#index' do
    get('/').should route_to('vacancies#index')
  end
  
  # Vacancies
  it 'should routes to vacancies#index' do
    get('/vacancies').should route_to('vacancies#index')
  end

  it 'should routes to vacancies#show' do
    get('/vacancies/1').should route_to('vacancies#show', id: '1')
  end

  it 'should routes to vacancies#new' do
    get('/vacancies/new').should route_to('vacancies#new')
  end

  it 'should routes to vacancies#create' do
    post('/vacancies').should route_to('vacancies#create')
  end

  it 'should routes to vacancies#edit' do
    get('/vacancies/1/edit').should route_to('vacancies#edit', id: '1')
  end

  it 'should routes to vacancies#update' do
    patch('/vacancies/1').should route_to('vacancies#update', id: '1')
  end

  # Pages
  it 'should routes to pages#about' do
    get('/about').should route_to('pages#about')
  end

  it 'should routes to pages#terms' do
    get('/terms').should route_to('pages#terms')
  end
  
  # Sessions
  it 'should routes to devise/sessions#new' do
    get('/login').should route_to('devise/sessions#new')
  end

  it 'should routes to devise/sessions#create' do
    post('/login').should route_to('devise/sessions#create')
  end

  it 'should routes to devise/sessions#destroy' do
    delete('/logout').should route_to('devise/sessions#destroy')
  end

  # Administration
  it 'should routes to admin/vacancies#index' do
    get('/admin/vacancies?awaiting_approve=1').should route_to('admin/vacancies#index', awaiting_approve: '1')
  end

  %w(vacancies occupations admins).each do |resources|
    it "should routes to admin/#{resources}#index" do
      get("/admin/#{resources}").should route_to("admin/#{resources}#index")
    end

    it "should routes to admin/#{resources}#new" do
      get("/admin/#{resources}/new").should route_to("admin/#{resources}#new")
    end

    it "should routes to admin/#{resources}#create" do
      post("/admin/#{resources}").should route_to("admin/#{resources}#create")
    end

    it "should routes to admin/#{resources}#edit" do
      get("/admin/#{resources}/1/edit").should route_to("admin/#{resources}#edit", id: '1')
    end

    it "should routes to admin/#{resources}#update" do
      patch("/admin/#{resources}/1").should route_to("admin/#{resources}#update", id: '1')
    end

    it "should routes to admin/#{resources}#destroy" do
      delete("/admin/#{resources}/1").should route_to("admin/#{resources}#destroy", id: '1')
    end
  end
end