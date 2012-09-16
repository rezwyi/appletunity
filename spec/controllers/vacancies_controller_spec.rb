require 'spec_helper'

describe VacanciesController do
  describe 'GET' do
    before :each do
      approved = true
      10.times do
        FactoryGirl.create(:vacancy, :approved => approved)
        approved = !approved
      end
    end

    context '#feed' do
      it 'should return approved and not expired vacancies' do
        get :feed, :format => :rss
        assigns[:vacancies].length.should == 5
        response.should render_template('feed')
        response.content_type.should eq('application/rss+xml')
      end
    end
  end

  describe 'POST' do
    context '#create' do
      context 'when created successfull' do
        before :each do
          @vacancy = FactoryGirl.build(:vacancy)
          Vacancy.should_receive(:new).and_return(@vacancy)
        end

        it 'assigns created vacancy' do
          post :create
          assigns[:vacancy].should_not be_nil
        end

        it 'sets flash[:message] message' do
          post :create
          flash[:message].should eq I18n.t('.vacancy_created_successfull',
                                           :email => assigns[:vacancy].contact_email)
        end

        it 'sends created email' do
          VacancyMailer.should_receive(:delay).and_return(VacancyMailer)
          VacancyMailer.should_receive(:created).with(@vacancy)
          post :create
        end

        it 'redirects to root url' do
          post :create
          response.should redirect_to(root_url)
        end
      end

      context 'when created unsuccessfull' do
        before :each do
          vacancy = mock_model(Vacancy)
          Vacancy.stub(:new).and_return(vacancy)
          vacancy.stub(:save).and_return(false)
        end

        it 'should render new action again' do
          post :create
          response.should render_template('new')
        end
      end
    end
  end
end