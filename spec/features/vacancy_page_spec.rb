require 'spec_helper'

describe 'Vacancy page' do
  context 'when view expired vacancy' do
    let(:vacancy) do
      FactoryGirl.create(:vacancy, :expired_at => 1.day.ago)
    end

    it 'should display expired note' do
      visit vacancy_path(vacancy)
      page.should have_no_selector('.vacancy-in-footer .zurb-button')
      find('.vacancy-in-footer .alert-error')\
        .should have_content(I18n.t(:expired_note))
    end
  end
end
