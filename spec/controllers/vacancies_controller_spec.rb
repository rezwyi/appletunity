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
      get :feed, format: :rss
      response.should be_success
    end

    it 'should find some vacancies' do
      get :feed, format: :rss
      assigns[:vacancies].should == [vacancy]
    end

    it 'should render feed template' do
      get :feed, format: :rss
      response.should render_template(:feed)
    end
  end

  describe '#show' do
    it 'should be success' do
      get :show, id: vacancy.id
      response.should be_success
    end

    it 'should find vacancy' do
      get :show, id: vacancy.id
      assigns[:resource].should == vacancy
    end

    it 'should render vacancy' do
      get :show, id: vacancy.id
      response.should render_template(:show)
    end

    context 'if vacancy is expired' do
      let(:expired_vacancy) { FactoryGirl.create(:vacancy, expired_at: 5.days.ago) }
      
      it 'should be success' do
        get :show, id: expired_vacancy.id
        response.should be_success
      end

      it 'should find expired vacancy' do
        get :show, id: expired_vacancy.id
        assigns[:resource].should == expired_vacancy
      end

      it 'should render' do
        get :show, id: expired_vacancy.id
        response.should render_template(:show)
      end
    end

    context 'if vacancy is not approved' do
      let(:not_approved_vacancy) { FactoryGirl.create(:vacancy, approved: false) }      

      it 'should raise routing error if user is not logged in' do
        expect { get(:show, id: not_approved_vacancy.id) }.to raise_error(ActionController::RoutingError)
      end

      it 'should find vacancy if user is logged in' do
        sign_in admin
        get :show, id: not_approved_vacancy.id
        assigns[:resource].should == not_approved_vacancy
      end
    end
  end

  context '#create' do
    let(:params) do
      FactoryGirl.build(:vacancy).attributes.slice(
        'title', 'body', 'company_name', 'contact_email', 'agreed_to_offer'
      )
    end

    it 'should save record to database' do
      expect { post(:create, vacancy: params) }.to change(Vacancy, :count).by(1)
    end

    it 'should show flash notice' do
      post :create, vacancy: params
      flash[:notice].should == I18n.t('messages.vacancy_created_successfull', email: params['contact_email'])
    end

    it 'should redirect to root' do
      post :create, vacancy: params
      response.should redirect_to(root_path)
    end

    context 'if not successfull' do
      before { Vacancy.any_instance.stub(:save).and_return(false) }

      it 'should redirect to vacancies' do
        post :create, vacancy: params
        response.should redirect_to(root_path)
      end
    end
  end

  describe '#edit' do
    it 'should render edit template' do
      get :edit, id: vacancy.id, token: vacancy.edit_token
      response.should render_template(:edit)
    end

    it 'should render edit template' do
      sign_in admin
      get :edit, id: vacancy.id, token: 'some-bad-token'
      response.should render_template(:edit)
    end

    it 'should raise error' do
      expect {
        get :edit, id: vacancy.id, token: 'some-bad-token'
      }.to raise_error(ActionController::RoutingError)
    end

    it 'should raise error' do
      expect { get :edit, id: vacancy.id }.to raise_error(ActionController::RoutingError)
    end
  end

  describe '#update' do
    let(:params) do
      {title: 'New title', body: 'New body', contact_email: 'new_email@example.com'}
    end

    it 'should not update vacancy title' do
      put :update, id: vacancy.id, vacancy: params
      vacancy.reload
      vacancy.title.should == 'Some title'
    end

    it 'should show flash notice' do
      put :update, id: vacancy.id, vacancy: params
      flash[:notice].should == I18n.t('messages.vacancy_updated_successfull')
    end

    it 'should redirect to vacancy' do
      put :update, id: vacancy.id, vacancy: params
      response.should redirect_to(vacancy)
    end

    context 'when not successfull' do
      before { Vacancy.any_instance.stub(:save).and_return(false) }

      it 'should not show flash notice' do
        put :update, id: vacancy.id, vacancy: params
        flash[:notice].should be_nil
      end

      it 'should redirect to vacancy' do
        put :update, id: vacancy.id, vacancy: params
        response.should redirect_to(vacancy)
      end
    end
  end
end