require 'spec_helper'

describe Appletunity::Finders::Base do
  before :each do
    params = { :first => 'first', :second => 'second' }
    @finder = Appletunity::Finders::Base.new(params)
  end

  it 'should transformate params to methods' do
    @finder.first.should eq 'first'
    @finder.second.should eq 'second'
  end

  it 'it should return no vacancies' do
    @finder.retrieve.count.should == 0
  end
end