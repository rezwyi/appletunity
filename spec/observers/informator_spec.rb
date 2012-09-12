require 'spec_helper'

describe Informator do
  subject { Informator.instance }
  
  context 'after create new vacancy' do
    before :each do
      @vacancy = FactoryGirl.create(:vacancy)
    end

    it 'should send tweet about it' do
      url = Rails.application.routes.url_helpers.vacancy_url(@vacancy)
      status = "[#{@vacancy.company_name}] #{url} #appletunity"
      
      Twitter.stub(:delay).and_return(Twitter)
      Twitter.should_receive(:update).with(status)
      
      subject.after_create(@vacancy)
    end
  end
end