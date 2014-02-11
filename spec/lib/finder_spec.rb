require 'spec_helper'

describe Finder do
  subject do
    Finder.new({
      first: 'first',
      second: 'second',
      filter: {'keywords' => 'Some body'}
    })
  end

  it 'should convert params to methods' do
    subject.first.should eq 'first'
    subject.second.should eq 'second'
  end

  it 'should find no vacancies' do
    subject.retrieve.should be_empty
  end

  it 'should find no vacancies' do
    vacancy = FactoryGirl.create(:vacancy, approved: false)
    subject.retrieve.should be_empty
  end

  it 'should find some vacancies' do
    vacancy = FactoryGirl.create(:vacancy)
    subject.retrieve.map(&:id).include?(vacancy.id).should be_true
  end

  it 'should find some vacancies' do
    vacancy = FactoryGirl.create(:vacancy, body: 'Some *body*')
    subject.retrieve.map(&:id).include?(vacancy.id).should be_true
  end
end
