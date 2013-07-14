require 'spec_helper'

describe 'Vacancies page' do
  it 'expired vacancies should be transparent' do
    id = FactoryGirl.create(:vacancy, :expired_at => 1.day.ago).id
    visit vacancies_path
    find("#vacancy_#{id}")[:class].should =~ /expired/
  end
end

