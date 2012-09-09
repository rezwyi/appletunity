require 'spec_helper'

describe Appletunity::Finders::Base do
  subject do
    params = {:first => 'first', :second => 'second',
              :filter => {'keywords' => 'Some title'}}
    Appletunity::Finders::Base.new(params)
  end

  it 'should convert params to methods' do
    subject.first.should eq 'first'
    subject.second.should eq 'second'
  end

  it 'should return no vacancies' do
    subject.retrieve.should be_empty
  end

  it 'should return some vacancies' do
    vacancy = FactoryGirl.build(:vacancy)
    vacancy.save!
    subject.retrieve.map(&:id).include?(vacancy.id).should be_true
  end
end