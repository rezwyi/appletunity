require 'spec_helper'

describe 'vacancies/feed.rss.builder' do
  it 'should render vacancies in rss format' do
    assign :vacancies, [FactoryGirl.build(:vacancy)]
    render
  end
end