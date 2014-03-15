require 'spec_helper'

describe LogosController do
  describe '#create' do
    let(:params) do
      {format: :json, logo: {image: fixture_file_upload(Rails.root.join('spec', 'images', 'logo.png'), 'image/png')}}
    end

    it 'should create logo' do
      expect { post(:create, params) }.to change(Logo, :count).by(1)
    end

    it 'should response with 200' do
      post :create, params
      response.should be_success
    end

    context 'when image already exists' do
      before { FactoryGirl.create(:logo) }

      it 'should not create logo' do
        expect { post(:create, params) }.not_to change(Logo, :count).by(1)
      end

      it 'should response with 200' do
        post :create, params
        response.should be_success
      end
    end

    context 'when wrong file format' do
      let(:params) do
        {format: :json, logo: {image: fixture_file_upload(Rails.root.join('spec', 'images', 'logo.tiff'), 'image/tiff')}}
      end

      it 'should not create logo' do
        expect { post(:create, params) }.not_to change(Logo, :count).by(1)
      end

      it 'should response with 422' do
        post :create, params
        response.status.should == 422
      end
    end

    context 'when image too small' do
      let(:params) do
        {format: :json, logo: {image: fixture_file_upload(Rails.root.join('spec', 'images', 'logo_small.png'), 'image/png')}}
      end

      it 'should not create logo' do
        expect { post(:create, params) }.not_to change(Logo, :count).by(1)
      end

      it 'should response with 422' do
        post :create, params
        response.status.should == 422
      end
    end
  end
end