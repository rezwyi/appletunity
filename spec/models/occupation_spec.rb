require 'spec_helper'

describe Occupation do
  it { should validate_presence_of :name }
end