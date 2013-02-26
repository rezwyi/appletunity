require 'rspec/matchers/built_in/base_matcher'

module Matchers
  class EmailAboutCreated < RSpec::Matchers::BuiltIn::BaseMatcher
    def matches?(mailer)
      mailer.stub(:delay).and_return(mailer)
      mailer.should_receive(:created)
    end
  end

  def email_about_created
    EmailAboutCreated.new
  end
end
