require 'spec_helper'

describe Region do
	it { should_not be_valid }
  it { should validate_presence_of :name }
end