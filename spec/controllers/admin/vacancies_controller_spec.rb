require 'spec_helper'

describe Admin::VacanciesController do
  describe '#index' do
    it 'should redirect to new admin session' do
      get :index
      response.should redirect_to(new_admin_session_path)
    end

    context 'when admin signed in' do
      before { sign_in(FactoryGirl.create(:admin)) }

      it 'should response with 200' do
        get :index
        response.should be_success
      end
    end
  end

  describe '#new' do
    it 'should redirect to new admin session' do
      get :new
      response.should redirect_to(new_admin_session_path)
    end

    context 'when admin signed in' do
      before { sign_in(FactoryGirl.create(:admin)) }

      it 'should response with 200' do
        get :new
        response.should be_success
      end
    end
  end

  context '#create' do
    let(:params) {{
      vacancy: {
        title: 'Some title',
        body: 'Some body',
        company_name: 'Some company',
        contact_email: 'contact@example.com',
        agreed_to_offer: true,
        approved: true
      }
    }}

    it 'should not create vacancy' do
      expect { post(:create, params) }.not_to change(Vacancy, :count)
    end

    it 'should redirect to new admin session' do
      post :create, params
      response.should redirect_to(new_admin_session_path)
    end

    context 'when admin signed in' do
      before { sign_in(FactoryGirl.create(:admin)) }
      
      it 'should create vacancy' do
        expect { post(:create, params) }.to change(Vacancy, :count).by(1)
      end

      it 'should show flash notice' do
        post :create, params
        flash[:notice].should == 'Vacancy created successfull!'
      end

      it 'should redirect to awaiting approve vacancies' do
        post :create, params
        response.should redirect_to(admin_vacancies_path(awaiting_approve: '1'))
      end

      context 'and not successfull' do
        before { Vacancy.any_instance.stub(:save).and_return(false) }

        it 'should not create vacancy' do
          expect { post(:create, params) }.not_to change(Vacancy, :count)
        end

        it 'should redirect to awaiting approve vacancies' do
          post :create, params
          response.should redirect_to(admin_vacancies_path(awaiting_approve: '1'))
        end
      end
    end
  end

  describe '#edit' do
    let(:vacancy) { FactoryGirl.create(:vacancy) }
    
    it 'should redirect to new admin session' do
      get :edit, id: vacancy.id
      response.should redirect_to(new_admin_session_path)
    end

    context 'when admin signed in' do
      before { sign_in(FactoryGirl.create(:admin)) }

      it 'should response with 200' do
        get :edit, id: vacancy.id
        response.should be_success
      end
    end
  end

  describe '#update' do
    let(:vacancy) { FactoryGirl.create(:vacancy, approved: false) }
    
    let(:params) {{
      id: vacancy.id,
      approved: true,
      vacancy: {
        title: 'New title',
        body: 'New body',
        contact_email: 'new_email@example.com',
        agreed_to_offer: true
      }
    }}

    it 'should not update vacancy approvement' do
      expect { patch(:update, params); vacancy.reload }.not_to change(vacancy, :approved)
    end

    it 'should redirect to new admin session' do
      patch :update, params
      response.should redirect_to(new_admin_session_path)
    end

    context 'when admin signed in' do
      before { sign_in(FactoryGirl.create(:admin)) }

      it 'should approve vacancy' do
        expect { patch(:update, params); vacancy.reload }.to change(vacancy, :approved).to(true)
      end

      it 'should show flash message' do
        patch :update, params
        flash[:notice].should == 'Vacancy updated successfull!'
      end

      it 'should redirect to awaiting approve vacancies' do
        patch :update, params
        response.should redirect_to(admin_vacancies_path(awaiting_approve: '1'))
      end

      context 'and not successfull' do
        before { Vacancy.any_instance.stub(:save).and_return(false) }
        
        it 'should not show flash message' do
          patch :update, params
          flash[:notice].should be_nil
        end

        it 'should redirect to awaiting approve vacancies' do
          patch :update, params
          response.should redirect_to(admin_vacancies_path(awaiting_approve: '1'))
        end        
      end
    end
  end

  describe '#destroy' do
    before { vacancy }
    
    let(:vacancy) { FactoryGirl.create(:vacancy) }
    let(:params) { {id: vacancy.id} }

    it 'should not destroy vacancy' do
      expect { delete(:destroy, params) }.not_to change(Vacancy, :count)
    end

    it 'should redirect to new admin session' do
      delete :destroy, params
      response.should redirect_to(new_admin_session_path)
    end

    context 'when admin signed in' do
      before { sign_in(FactoryGirl.create(:admin)) }

      it 'should destroy vacancy' do
        expect { delete(:destroy, params) }.to change(Vacancy, :count).by(-1)
      end

      it 'should show flash message' do
        delete :destroy, params
        flash[:notice].should == 'Vacancy removed successfull!'
      end

      it 'should redirect to awaiting approve vacancies' do
        delete :destroy, params
        response.should redirect_to(admin_vacancies_path)
      end
    end
  end
end