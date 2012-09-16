require 'spec_helper'

describe VacanciesController do
  before :each do
    approved = true
    10.times do
      FactoryGirl.create(:vacancy, :approved => approved)
      approved = !approved
    end
  end

  context 'GET feed' do
    it 'should return approved and not expired vacancies' do
      get :feed, :format => :rss
      assigns[:vacancies].length.should == 5
      response.should render_template('feed')
      response.content_type.should eq('application/rss+xml')
    end
  end
end