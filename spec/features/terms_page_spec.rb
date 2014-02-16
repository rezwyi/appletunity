require 'spec_helper'

describe 'Terms page' do
  it 'should not show breadcrumbs' do
    visit terms_page_path
    page.should_not have_css('#breadcrumbs')
  end
end