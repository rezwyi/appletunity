require 'spec_helper'

describe VacanciesController do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:vacancy) { FactoryGirl.create(:vacancy) }

  describe '#index' do
    it 'should be success' do
      get :index
      response.should be_success
    end

    it 'should find some vacancies' do
      get :index
      assigns[:vacancies].should == [vacancy]
    end

    it 'should render index template' do
      get :index
      response.should render_template(:index)
    end
  end

  describe '#feed' do
    it 'should be success' do
      get :feed, :format => :rss
      response.should be_success
    end

    it 'should find some vacancies' do
      get :feed, :format => :rss
      assigns[:vacancies].should == [vacancy]
    end

    it 'should render feed template' do
      get :feed, :format => :rss
      response.should render_template(:feed)
    end
  end

  describe '#show' do
    it 'should be success' do
      get :show, :id => vacancy.id
      response.should be_success
    end

    it 'should find vacancy' do
      get :show, :id => vacancy.id
      assigns[:vacancy].should == vacancy
    end

    it 'should render vacancy' do
      get :show, :id => vacancy.id
      response.should render_template(:show)
    end

    context 'if vacancy is expired' do
      let(:expired_vacancy) { FactoryGirl.create(:vacancy, :expired_at => 5.days.ago) }
      
      it 'should be success' do
        get :show, :id => expired_vacancy.id
        response.should be_success
      end

      it 'should find expired vacancy' do
        get :show, :id => expired_vacancy.id
        assigns[:vacancy].should == expired_vacancy
      end

      it 'should render' do
        get :show, :id => expired_vacancy.id
        response.should render_template(:show)
      end
    end

    context 'if vacancy is not approved' do
      let(:not_approved_vacancy) { FactoryGirl.create(:vacancy, :approved => false) }      

      it 'should render 404' do
        get :show, :id => vacancy.id
        response.status.should == 404
      end

      it 'should find vacancy if user is logged in' do
        sign_in admin
        get :show, :id => not_approved_vacancy.id
        assigns[:vacancy].should == not_approved_vacancy
      end
    end
  end

  context '#create' do
    let(:params) do
      FactoryGirl.build(:vacancy).attributes.slice(
        'title', 'body', 'company_name', 'contact_email', 'agreed_to_offer'
      )
    end

      end
    it 'should save record to database' do
      expect { post(:create, :vacancy => params) }.to change(Vacancy, :count).by(1)
    end

    it 'should show flash notice' do
      post :create, :vacancy => params
      flash[:notice].should == I18n.t('.vacancy_created_successfull', :email => params['contact_email'])
    end

    it 'should redirect to root' do
      post :create, :vacancy => params
      response.should redirect_to(root_url)
    end

    context 'if not successfull' do
      before { Vacancy.any_instance.stub(:save).and_return(false) }

      it 'should redirect to vacancies' do
        post :create, :vacancy => params
        response.should redirect_to(vacancies_path)
      end
    end
  end

  describe '#edit' do
    it 'should render edit template' do
      get :edit, :id => vacancy.id, :token => vacancy.edit_token
      response.should render_template(:edit)
    end

    it 'should render edit template' do
      sign_in admin
      get :edit, :id => vacancy.id, :token => 'some-bad-token'
      response.should render_template(:edit)
    end

    it 'should render 404' do
      get :edit, :id => vacancy.id, :token => 'some-bad-token'
      response.status.should == 404
    end

    it 'should render 404' do
      get :edit, :id => vacancy.id
      response.status.should == 404
    end
  end

  describe '#update' do
    before { FactoryGirl.create(:vacancy) }

    let(:params) {{
      :title => 'New title',
      :body => 'New body',
      :contact_email => 'new_email@example.com'
    }}

    it 'should update vacancy title' do
      post :update, :id => vacancy.id, :vacancy => params
      vacancy.reload
      vacancy.title.should == 'New title'
      vacancy.body.should == 'New body'
      vacancy.contact_email.should == 'new_email@example.com'
    end

    it 'should not update vacancy edit token' do
      expect {
        post :update, :id => vacancy.id, :vacancy => {:edit_token => 'new-token'}
      }.to raise_error
    end

    it 'should show flash notice' do
      post :update, :id => vacancy.id, :vacancy => params
      flash[:notice].should == I18n.t('.vacancy_updated_successfull')
    end

    it 'should redirect to vacancy' do
      post :update, :id => vacancy.id, :vacancy => params
      vacancy.reload
      response.should redirect_to(vacancy_path(vacancy))
    end

    context 'if not successfull' do
      before { Vacancy.any_instance.stub(:update_attributes).and_return(false) }

      it 'should redirect to vacancy' do
        post :update, :id => vacancy.id, :vacancy => params
        response.should redirect_to(vacancy_path(vacancy))
      end
    end
  end
end
