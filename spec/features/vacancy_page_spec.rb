require 'spec_helper'

describe 'Vacancy page' do
	let(:vacancy) { FactoryGirl.create(:vacancy) }
	
	it 'should show company website started with http' do
    visit vacancy_path(vacancy)
    find('.company-logo a')[:href].should == 'http://example.com'
  end
  
  context 'when view expired vacancy' do
    let(:expired_vacancy) { FactoryGirl.create(:vacancy, expired_at: 1.day.ago) }

    it 'should display expired note' do
      visit vacancy_path(expired_vacancy)
      find('.footer .expired-note').should have_content(I18n.t('ui.vacancies.text.expired_note'))
    end
  end
end