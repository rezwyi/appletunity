require 'spec_helper'

describe VacanciesController do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:vacancy) { FactoryGirl.create(:vacancy) }

  describe '#index' do
    it 'should return approved vacancies' do
      get :index
      response.should render_template(:index)
    end
  end

  describe '#feed' do
    it 'should return approved vacancies' do
      get :feed, :format => :rss
      response.should render_template(:feed)
    end
  end

  describe '#show' do
    it 'should render vacancy' do
      get :show, :id => vacancy.id
      response.should render_template(:show)
    end

    it 'should render expired vacancy' do
      vacancy.update_attribute(:expired_at, 5.days.ago)
      get :show, :id => vacancy.id
      response.should render_template(:show)
    end

    context 'if vacancy is not approved' do
      before { vacancy.update_attribute(:approved, false) }

      it 'should render vacancy' do
        sign_in admin
        get :show, :id => vacancy.id
        response.should render_template(:show)
      end

      it 'should render 404' do
        get :show, :id => vacancy.id
        response.status.should == 404
      end
    end
  end

  context '#create' do
    let(:params) do
      FactoryGirl.build(:vacancy).attributes.slice(
        'title', 'body', 'company_name', 'contact_email', 'agreed_to_offer'
      )
    end

    context 'when created successfull' do
      it 'should save record to database' do
        expect {
          post :create, :vacancy => params
        }.to change(Vacancy, :count).by(1)
      end

      it 'should show flash message' do
        post :create, :vacancy => params
        flash[:message].should == I18n.t(
          '.vacancy_created_successfull',
          :email => params['contact_email']
        )
      end

      it 'should send created email' do
        VacancyMailer.should email_about_created
        post :create, :vacancy => params
      end

      it 'should redirect to root_url' do
        post :create, :vacancy => params
        response.should redirect_to(root_url)
      end
    end

    context 'when created unsuccessfull' do
      it 'should render new vacancy form again' do
        Vacancy.any_instance.stub(:save).and_return(false)
        post :create, :vacancy => params
        response.should render_template(:new)
      end
    end
  end

  describe '#edit' do
    it 'should render edit vacancy form' do
      get :edit, :id => vacancy.id, :token => vacancy.edit_token
      response.should render_template(:edit)
    end

    it 'should render edit vacancy form' do
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

    it 'shouldnt update vacancy edit token' do
      expect {
        post :update, :id => vacancy.id, :vacancy => {:edit_token => 'new-token'}
      }.to raise_error
    end

    it 'should redirect to vacancy' do
      post :update, :id => vacancy.id, :vacancy => params
      response.should redirect_to(vacancy_path(vacancy.id))
    end

    it 'should show flash message' do
      post :update, :id => vacancy.id, :vacancy => params
      flash[:message].should == I18n.t('.vacancy_updated_successfull')
    end

    it 'should render edit form again' do
      Vacancy.any_instance.stub(:update_attributes).and_return(false)
      post :update, :id => vacancy.id, :vacancy => params
      response.should render_template(:edit)
    end
  end
end
