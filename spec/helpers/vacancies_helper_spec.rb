require 'spec_helper'

describe VacanciesHelper do
  describe '#mailto_for' do
    it 'should return nil' do
      helper.mailto_for(nil).should be_nil
    end

    it 'should return right mailto string' do
      vacancy = mock_model(Vacancy)

      vacancy.stub(:title).and_return('some_title')
      vacancy.stub(:contact_email).and_return('some@email.com')
      
      helper.mailto_for(vacancy)\
            .should eq 'mailto:some@email.com?subject=some_title'
    end
  end
end