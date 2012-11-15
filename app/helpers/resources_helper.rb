module ResourcesHelper
  include Rails.application.routes.url_helpers

  # Public: Build link to edit resource (e.g. admin, vacancy)
  #
  # resource - Resource object (required)
  # options - The options Hash (default: {})
  #
  # Examples
  #
  #   link_to_edit_resource(vacancy)
  #
  # Returns html safe String
  def link_to_edit_resource(resource, options = {})
    return unless resource
    
    link_to t('edit'),
            polymorphic_path([:administration, resource], :action => :edit),
            options
  end
  
  # Public: Build link to delete resource (e.g. admin, vacancy)
  #
  # resource - Resource object (required)
  # options - The options Hash (default: {})
  #
  # Examples
  #
  #   link_to_delete_resource(vacancy)
  #
  # Returns html safe String
  def link_to_delete_resource(resource, options = {})
    return unless resource
    
    defaults = {:method => :delete, :data => {:confirm => I18n.t(:sure?)}}
    options = options.merge(defaults)
    
    link_to t('delete'), polymorphic_path([:administration, resource]), options
  end
end