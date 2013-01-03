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

  describe '#bootstrapize_flash_key' do
    it 'should be nil' do
      helper.bootstrapize_flash_key(nil).should be_nil
    end

    it 'should be nil' do
      helper.bootstrapize_flash_key(:test).should be_nil
    end

    it "should return 'alert-success'" do
      helper.bootstrapize_flash_key(:message).should == 'alert-success'
    end

    it "should return 'alert-success'" do
      helper.bootstrapize_flash_key(:notice).should == 'alert-success'
    end

    it "should return 'alert-error'" do
      helper.bootstrapize_flash_key(:error).should == 'alert-error'
    end

    it "should return 'alert-error'" do
      helper.bootstrapize_flash_key(:alert).should == 'alert-error'
    end
  end
end
