require 'spec_helper'

describe ApplicationHelper do
  describe '#copyright_years' do
    it "should return '2012'" do
      helper.copyright_years(:to => 2012).should eq '2012'
    end

    it "should return '2012-2015'" do
      helper.copyright_years(:to => 2015).should eq '2012-2015'
    end
  end
end