require 'spec_helper'

describe Vacancy do
  it { should_not be_valid }
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should validate_presence_of :company_name }
  it { should validate_presence_of :contact_email }
  it { should validate_presence_of :agreed_to_offer }

  context '#self.friendly_token' do
    it 'should return token' do
      SecureRandom.stub(:base64).and_return("+A/BC=\n")
      Vacancy.friendly_token.should eq '-A_BC'
    end
  end
end