require 'spec_helper'

describe Admin::AdminsController do
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
    let(:params) do
      {admin: {email: 'admin@example.com', password: '12345678', password_confirmation: '12345678'}}
    end

    it 'should not create admin' do
      expect { post(:create, params) }.not_to change(Admin, :count)
    end

    it 'should redirect to new admin session' do
      post :create, params
      response.should redirect_to(new_admin_session_path)
    end

    context 'when admin signed in' do
      before { sign_in(FactoryGirl.create(:admin)) }
      
      it 'should create admin' do
        expect { post(:create, params) }.to change(Admin, :count).by(1)
      end

      it 'should show flash notice' do
        post :create, params
        flash[:notice].should == 'Admin created successfull!'
      end

      it 'should redirect to admins' do
        post :create, params
        response.should redirect_to(admin_admins_path)
      end

      context 'and not successfull' do
        before { Admin.any_instance.stub(:save).and_return(false) }

        it 'should not create admin' do
          expect { post(:create, params) }.not_to change(Admin, :count)
        end

        it 'should redirect to admins' do
          post :create, params
          response.should redirect_to(admin_admins_path)
        end
      end
    end
  end

  describe '#edit' do
    let(:admin) { FactoryGirl.create(:admin) }
    
    it 'should redirect to new admin session' do
      get :edit, id: admin.id
      response.should redirect_to(new_admin_session_path)
    end

    context 'when admin signed in' do
      before { sign_in(FactoryGirl.create(:admin)) }

      it 'should response with 200' do
        get :edit, id: admin.id
        response.should be_success
      end
    end
  end

  describe '#update' do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:params) { {id: admin.id, admin: {email: 'root@example.com'}} }

    it 'should not update admin email' do
      expect { patch(:update, params); admin.reload }.not_to change(admin, :email)
    end

    it 'should redirect to new admin session' do
      patch :update, params
      response.should redirect_to(new_admin_session_path)
    end

    context 'when admin signed in' do
      before { sign_in(FactoryGirl.create(:admin)) }

      it 'should update admin name' do
        expect { patch(:update, params); admin.reload }.to change(admin, :email).to('root@example.com')
      end

      it 'should show flash message' do
        patch :update, params
        flash[:notice].should == 'Admin updated successfull!'
      end

      it 'should redirect to admins' do
        patch :update, params
        response.should redirect_to(admin_admins_path)
      end

      context 'and not successfull' do
        before { Admin.any_instance.stub(:save).and_return(false) }
        
        it 'should not show flash message' do
          patch :update, params
          flash[:notice].should be_nil
        end

        it 'should redirect to admins' do
          patch :update, params
          response.should redirect_to(admin_admins_path)
        end        
      end
    end
  end

  describe '#destroy' do
    before { admin }
    
    let(:admin) { FactoryGirl.create(:admin) }
    let(:params) { {id: admin.id} }

    it 'should not destroy admin' do
      expect { delete(:destroy, params) }.not_to change(Admin, :count)
    end

    it 'should redirect to new admin session' do
      delete :destroy, params
      response.should redirect_to(new_admin_session_path)
    end

    context 'when admin signed in' do
      before { sign_in(me) }

      let(:me) { FactoryGirl.create(:admin) }

      it 'should destroy admin' do
        expect { delete(:destroy, params) }.to change(Admin, :count).by(-1)
      end

      it 'should show flash message' do
        delete :destroy, params
        flash[:notice].should == 'Admin removed successfull!'
      end

      it 'should redirect to admins' do
        delete :destroy, params
        response.should redirect_to(admin_admins_path)
      end

      context 'and trying to destroy yourself' do
        let(:params) { {id: me.id} }
        
        it 'shoud not destroy yourself' do
          expect { delete(:destroy, id: me.id) }.not_to change(Admin, :count)
        end

        it 'shoud show flash alert' do
          delete :destroy, params
          flash[:alert].should == 'Cannot delete yourself!'
        end

        it 'should redirect to admins' do
          delete :destroy, params
          response.should redirect_to(admin_admins_path)
        end
      end
    end
  end
end