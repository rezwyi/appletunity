require 'spec_helper'

describe Vacancy do
  it { should_not be_valid }
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should validate_presence_of :contact_email }
  it { should validate_presence_of :agreed_to_offer }

  context '#self.friendly_token' do
    it 'should return token' do
      SecureRandom.stub(:base64).and_return("+A/BC=\n")
      Vacancy.friendly_token.should eq '-A_BC'
    end
  end

  context 'instance' do
    before :each do
      @vacancy = Vacancy.new
    end
    
    context '#short_description' do
      it 'should return description' do
        @vacancy.stub(:description).and_return('d')
        @vacancy.short_description.should eq 'd'
      end

      it 'should return cropped description' do
        @vacancy.stub(:description).and_return('d' * 141)
        @vacancy.short_description.should eq ('d' * 137 + '...')
      end
    end
  end
end