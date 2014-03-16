require 'spec_helper'

describe VacanciesController do
  describe '#index' do
    it 'should response with 200' do
      get :index
      response.should be_success
    end
  end

  describe '#feed' do
    it 'should response with 200' do
      get :feed, format: :rss
      response.should be_success
    end

    it 'should render feed template' do
      get :feed, format: :rss
      response.should render_template(:feed)
    end
  end

  describe '#show' do
    let(:vacancy) { FactoryGirl.create(:vacancy) }
    
    it 'should response with 200' do
      get :show, id: vacancy.id
      response.should be_success
    end

    context 'if vacancy is expired' do
      let(:vacancy) { FactoryGirl.create(:vacancy, expired_at: 5.days.ago) }
      
      it 'should response with 200' do
        get :show, id: vacancy.id
        response.should be_success
      end
    end

    context 'if vacancy is not approved' do
      before { vacancy }
      
      let(:vacancy) { FactoryGirl.create(:vacancy, approved: false) }

      it 'should raise routing error' do
        expect { get(:show, id: vacancy.id) }.to raise_error(ActionController::RoutingError)
      end

      context 'and admin signed in' do
        before { sign_in(FactoryGirl.create(:admin)) }

        it 'should response with 200' do
          get :show, id: vacancy.id
          response.should be_success
        end
      end
    end
  end

  context '#create' do
    let(:params) {{
      format: 'json',
      vacancy: {
        title: 'Some title',
        body: 'Some body',
        company_name: 'Some company',
        contact_email: 'contact@example.com',
        agreed_to_offer: true
      }
    }}

    it 'should create vacancy' do
      expect { post(:create, params) }.to change(Vacancy, :count).by(1)
    end

    it 'should show flash notice' do
      post :create, params
      flash[:notice].should == I18n.t('messages.vacancy_created_successfull', email: 'contact@example.com')
    end

    it 'should response with 201' do
      post :create, params
      response.status.should == 201
    end

    context 'when errors present' do
      before { params.deep_merge!(vacancy: {body: ''}) }

      it 'should not create vacancy' do
        expect { post(:create, params) }.not_to change(Vacancy, :count)
      end

      it 'should response with 422' do
        post :create, params
        response.status.should == 422
      end
    end

    context 'when user is not agreed with offer' do
      before { params.deep_merge!(vacancy: {agreed_to_offer: false}) }

      it 'should not create vacancy' do
        expect { post(:create, params) }.not_to change(Vacancy, :count)
      end

      it 'should response with 422' do
        post :create, params
        response.status.should == 422
      end
    end
  end

  describe '#edit' do
    let(:vacancy) { FactoryGirl.create(:vacancy) }
    let(:params) { {id: vacancy.id, token: vacancy.edit_token} }

    it 'should response with 200' do
      get :edit, params
      response.should be_success
    end

    context 'when wrong token given' do
      let(:params) { {id: vacancy.id, token: 'bad-token'} }
      
      it 'should raise routing error' do
        expect { get(:edit, params) }.to raise_error(ActionController::RoutingError)
      end

      context 'and admin signed in' do
        before { sign_in(FactoryGirl.create(:admin)) }
        
        it 'should response with 200' do
          get :edit, params
          response.should be_success
        end
      end
    end
  end

  describe '#update' do
    let(:vacancy) { FactoryGirl.create(:vacancy) }
    
    let(:params) {{
      format: 'json',
      token: vacancy.edit_token,
      id: vacancy.id,
      vacancy: {
        title: 'New title',
        body: 'New body',
        contact_email: 'new_email@example.com',
        agreed_to_offer: false
      }
    }}

    it 'should not update vacancy title' do
      expect { put(:update, params) && vacancy.reload }.not_to change(vacancy, :title)
    end

    it 'should not update agreed to offer' do
      expect { put(:update, params) && vacancy.reload }.not_to change(vacancy, :agreed_to_offer)
    end

    it 'should show flash notice' do
      put :update, params
      flash[:notice].should == I18n.t('messages.vacancy_updated_successfull')
    end

    it 'should response with 200' do
      put :update, params
      response.should be_success
    end

    context 'when errors peresent' do
      before { params.deep_merge!(vacancy: {body: ''}) }

      it 'should response with 422' do
        put :update, params
        response.status.should == 422
      end
    end

    context 'when wrong token given' do
      before { params.merge!(token: 'bad-token') }
      
      it 'should raise routing error' do
        expect { put(:update, params) }.to raise_error(ActionController::RoutingError)
      end

      context 'and admin signed in' do
        before { sign_in(FactoryGirl.create(:admin)) }

        it 'should response with 200' do
          put :update, params
          response.should be_success
        end
      end
    end
  end
end