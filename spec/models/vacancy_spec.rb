require 'spec_helper'

describe Vacancy do
  it { should_not be_valid }
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should validate_presence_of :contact_email }
  it { should validate_presence_of :agreed_to_offer }
end