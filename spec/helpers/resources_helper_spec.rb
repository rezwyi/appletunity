require 'spec_helper'

describe VacanciesHelper do
  describe '#link_to_edit_resource' do
    it 'should return nil' do
      helper.link_to_edit_resource(nil).should be_nil
    end

    it 'should return correct link' do
      vacancy = mock_model(Vacancy)
      vacancy.stub(:id).and_return(1)
      helper.link_to_edit_resource(vacancy)\
            .start_with?(%(<a href="/administration/vacancies/1/edit">))\
            .should be_true
    end
  end

  describe '#link_to_delete_resource' do
    it 'should return nil' do
      helper.link_to_delete_resource(nil).should be_nil
    end
  end
end