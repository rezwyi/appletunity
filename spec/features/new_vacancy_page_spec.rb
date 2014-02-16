require 'spec_helper'

describe 'New vacancy page' do
  it 'should show breadcrumbs' do
    visit new_vacancy_path
    page.should have_css('#breadcrumbs')
  end
end