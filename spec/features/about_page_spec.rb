require 'spec_helper'

describe 'About page' do
  it 'should not show breadcrumbs' do
    visit about_page_path
    page.should_not have_css('#breadcrumbs')
  end
end