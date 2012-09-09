require 'spec_helper'

describe Vacancy do
  subject { FactoryGirl.build(:vacancy) }
  
  it { Vacancy.new.should_not be_valid }
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :company_name }
  it { should validate_presence_of :contact_email }
  it { should validate_presence_of :agreed_to_offer }

  it 'can have several occupations' do
    occupations = [FactoryGirl.build(:occupation, :name => 'Fulltime'),
                   FactoryGirl.build(:occupation, :name => 'Freelance')]
    subject.occupations = occupations
    
    subject.save! and subject.reload
    subject.occupations.should eq occupations
  end

  context '#self.friendly_token' do
    it 'should return token' do
      SecureRandom.stub(:base64).and_return("+A/BC=\n")
      Vacancy.friendly_token.should eq '-A_BC'
    end
  end

  context 'before save' do
    it 'should generate edit_token' do
      subject.save!
      subject.edit_token.should_not be_nil
    end

    it 'should generate expired_at' do
      Time.stub(:now).and_return(Time.new)
      subject.save!
      subject.expired_at.should == Time.now + 7.days
    end

    it 'should render body to html' do
      html = Redcarpet::Markdown.new(Redcarpet::Render::Appletunity)\
                                .render(subject.body)
      subject.save!
      subject.rendered_body.should eq html
    end
  end

  context 'when save' do
    it 'should be valid' do
      subject.should be_valid
    end
  end
end