require 'spec_helper'

describe 'Vacancies page' do
  before { vacancy }
  
  let(:vacancy) { FactoryGirl.create(:vacancy) }
  
  it 'should show company website started with http' do
    visit vacancies_path
    find("#vacancy-#{vacancy.id} .company-logo a")[:href].should =~ /http:\/\/example.com/
  end

  context 'when vacancy is expired' do
    before { expired_vacancy }
    
    let(:expired_vacancy) { FactoryGirl.create(:vacancy, expired_at: 1.day.ago) }

    it 'expired vacancies should be transparent' do
      visit vacancies_path
      find("#vacancy-#{expired_vacancy.id}")[:class].should =~ /expired/
    end
  end
end