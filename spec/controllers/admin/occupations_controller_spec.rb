require 'spec_helper'

describe Admin::OccupationsController do
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
    let(:params) { {occupation: {name: 'Freelance'}} }

    it 'should not create occupation' do
      expect { post(:create, params) }.not_to change(Occupation, :count)
    end

    it 'should redirect to new admin session' do
      post :create, params
      response.should redirect_to(new_admin_session_path)
    end

    context 'when admin signed in' do
      before { sign_in(FactoryGirl.create(:admin)) }
      
      it 'should create occupation' do
        expect { post(:create, params) }.to change(Occupation, :count).by(1)
      end

      it 'should show flash notice' do
        post :create, params
        flash[:notice].should == 'Occupation created successfull!'
      end

      it 'should redirect to occupation' do
        post :create, params
        response.should redirect_to(admin_occupations_path)
      end

      context 'and not successfull' do
        before { Occupation.any_instance.stub(:save).and_return(false) }

        it 'should not create occupation' do
          expect { post(:create, params) }.not_to change(Occupation, :count)
        end

        it 'should redirect to occupations' do
          post :create, params
          response.should redirect_to(admin_occupations_path)
        end
      end
    end
  end

  describe '#edit' do
    let(:occupation) { FactoryGirl.create(:occupation) }
    
    it 'should redirect to new admin session' do
      get :edit, id: occupation.id
      response.should redirect_to(new_admin_session_path)
    end

    context 'when admin signed in' do
      before { sign_in(FactoryGirl.create(:admin)) }

      it 'should response with 200' do
        get :edit, id: occupation.id
        response.should be_success
      end
    end
  end

  describe '#update' do
    let(:occupation) { FactoryGirl.create(:occupation) }
    let(:params) { {id: occupation.id, occupation: {name: 'Contract'}} }

    it 'should not update occupation name' do
      expect { patch(:update, params); occupation.reload }.not_to change(occupation, :name)
    end

    it 'should redirect to new admin session' do
      patch :update, params
      response.should redirect_to(new_admin_session_path)
    end

    context 'when admin signed in' do
      before { sign_in(FactoryGirl.create(:admin)) }

      it 'should update occupation name' do
        expect { patch(:update, params); occupation.reload }.to change(occupation, :name).to('Contract')
      end

      it 'should show flash message' do
        patch :update, params
        flash[:notice].should == 'Occupation updated successfull!'
      end

      it 'should redirect to occupations' do
        patch :update, params
        response.should redirect_to(admin_occupations_path)
      end

      context 'and not successfull' do
        before { Occupation.any_instance.stub(:save).and_return(false) }
        
        it 'should not show flash message' do
          patch :update, params
          flash[:notice].should be_nil
        end

        it 'should redirect to occupations' do
          patch :update, params
          response.should redirect_to(admin_occupations_path)
        end        
      end
    end
  end

  describe '#destroy' do
    before { occupation }
    
    let(:occupation) { FactoryGirl.create(:occupation) }
    let(:params) { {id: occupation.id} }

    it 'should not destroy occupation' do
      expect { delete(:destroy, params) }.not_to change(Occupation, :count)
    end

    it 'should redirect to new admin session' do
      delete :destroy, params
      response.should redirect_to(new_admin_session_path)
    end

    context 'when admin signed in' do
      before { sign_in(FactoryGirl.create(:admin)) }

      it 'should destroy occupation' do
        expect { delete(:destroy, params) }.to change(Occupation, :count).by(-1)
      end

      it 'should show flash message' do
        delete :destroy, params
        flash[:notice].should == 'Occupation removed successfull!'
      end

      it 'should redirect to occupations' do
        delete :destroy, params
        response.should redirect_to(admin_occupations_path)
      end
    end
  end
end