require 'spec_helper'

describe Vacancy do
  subject { FactoryGirl.build(:vacancy) }
  
  it { Vacancy.new.should_not be_valid }
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :company_name }
  it { should validate_presence_of :contact_email }
  it { should validate_presence_of :agreed_to_offer }
  it { should validate_attachment_size(:logo).in(0..100.kilobytes) }

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
    it 'should be valid' do
      subject.should be_valid
    end

    it 'should validates length of title' do
      subject.title = '.' * 71
      subject.should have(1).error_on(:title)
    end

    it 'should validates length of company_name' do
      subject.company_name = '.' * 31
      subject.should have(1).error_on(:company_name)
    end

    it 'should validates format of contact_email' do
      subject.contact_email = '123'
      subject.should have(1).error_on(:contact_email)
    end
  end

  context 'when save' do
    it 'should generate edit_token' do
      subject.save!
      subject.edit_token.should_not be_nil
    end

    it 'should generate expired_at' do
      lifetime = Rails.application.config.default_vacancy_lifetime
      
      Time.stub(:now).and_return(Time.new)
      
      subject.save!
      subject.expired_at.should == Time.now + lifetime
    end

    it 'should leave expired_at empty if not approved' do
      subject.approved = false
      subject.save!
      subject.expired_at.should be_nil
    end

    it 'should allow b tag in body' do
      body = '<b>Some body</b>'
      subject.body = body
      subject.save!
      subject.rendered_body.should eq body
    end

    it 'should allow i and em tag in body' do
      body = '<i>Some</i> <em>body</em>'
      subject.body = body
      subject.save!
      subject.rendered_body.should eq body
    end

    it 'should allow h1 tag in body' do
      body = '<h1>Some body</h1>'
      subject.body = body
      subject.save!
      subject.rendered_body.should eq body
    end

    it 'should allow ol tag in body' do
      body = '<ol><li>Some list item</li></ol>'
      subject.body = body
      subject.save!
      subject.rendered_body.should eq body
    end

    it 'should sanitize link tag in body' do
      subject.body = '<a href="#">Some body</a>'
      subject.save!
      subject.rendered_body.should eq 'Some body'
    end

    it 'should sanitize script tag in body' do
      subject.body = '<script type="text/javascript">alert("Alert!")</script>'
      subject.save!
      subject.rendered_body.should eq ''
    end

    it 'should sanitize img tag in body' do
      subject.body = '<img src="#">'
      subject.save!
      subject.rendered_body.should eq ''
    end
  end
end
