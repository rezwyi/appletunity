require 'spec_helper'

describe PagesController do
  describe '#about' do
    it 'should response with 200' do
      get :about
      response.should be_success
    end

    it 'should render about template' do
      get :about
      response.should render_template(:about)
    end
  end

  describe '#terms' do
    it 'should response with 200' do
      get :terms
      response.should be_success
    end

    it 'should render terms template' do
      get :terms
      response.should render_template(:terms)
    end
  end
end