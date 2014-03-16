require 'spec_helper'

FactoryGirl.factories.map(&:name).each do |f|
  describe "The #{f} factory" do
    it 'should be valid' do
      FactoryGirl.build(f).should be_valid
    end
  end
end