class AppSpecificError < StandardError
  attr_accessor :resource

  def initialize(message = nil, resource = nil)
  	super message
  	self.resource = resource
  end
end