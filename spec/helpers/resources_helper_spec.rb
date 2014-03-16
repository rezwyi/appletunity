require 'spec_helper'

describe ResourcesHelper do
  let(:vacancy) { FactoryGirl.create(:vacancy) }
  
  describe '#link_to_edit_resource' do
    it 'should return nil' do
      helper.link_to_edit_resource(nil).should be_nil
    end

    it 'should return link' do
      helper.link_to_edit_resource(vacancy).should =~ /href="\/admin\/vacancies\/#{vacancy.to_param}\/edit"/
    end
  end

  describe '#link_to_delete_resource' do
    it 'should return nil' do
      helper.link_to_delete_resource(nil).should be_nil
    end

    it 'should return link' do
      helper.link_to_delete_resource(vacancy).should =~ /data-method="delete" href="\/admin\/vacancies\/#{vacancy.to_param}"/
    end
  end
end