module Redcarpet::Render
  class Appletunity < HTML
    def initialize(extensions = {})
      super(extensions.merge(:filter_html => true, :no_images => true,
                             :no_links => true, :no_styles => true))
    end
  end
end