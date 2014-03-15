require 'spec_helper'

describe Logoable do
  it { should validate_presence_of :resource }
  it { should validate_presence_of :logo }
end