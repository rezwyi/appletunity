require 'spec_helper'

describe VacanciesController do
  describe '#index' do
    let(:vacancy) { FactoryGirl.create(:vacancy) }

    it 'should return approved vacancies' do
      get :index
      response.should render_template(:index)
    end
  end

  describe '#feed' do
    let(:vacancy) { FactoryGirl.create(:vacancy) }

    it 'should return approved vacancies' do
      get :feed, :format => :rss
      response.should render_template(:feed)
    end
  end

  describe '#show' do
    let(:vacancy) { FactoryGirl.create(:vacancy) }

    it 'should render vacancy' do
      get :show, :id => vacancy.id
      response.should render_template(:show)
    end

    it 'should render expired vacancy' do
      vacancy.update_attribute(:expired_at, 5.days.ago)
      get :show, :id => vacancy.id
      response.should render_template(:show)
    end

    it 'should render 404' do
      vacancy.update_attribute(:approved, false)
      get :show, :id => vacancy.id
      response.status.should == 404
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
end
