require 'spec_helper'

describe Occupation do
  it { Occupation.new.should_not be_valid }
  it { should validate_presence_of :name }
end