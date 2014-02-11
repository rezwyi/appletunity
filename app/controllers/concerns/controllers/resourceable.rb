module Controllers::Resourceable
  extend ActiveSupport::Concern
  
  included do
    before_action :load_resource, except: %i(index feed)
  end

  def resource_name
    @resource_name ||= controller_name.classify
  end

  def resource_class
    @resource_class ||= resource_name.constantize rescue nil
  end

  def load_resource
    @resource = if resource_class && resource_class < ActiveRecord::Base
      namespace = resource_class.name.underscore.to_sym
      (params[:id].present? ? resource_class.find(params[:id]) : resource_class.new).tap do |r|
        if namespace.present? && params[namespace].present?
          r.assign_attributes send("#{action_name}_params", namespace) rescue nil
        end
      end
    end
  end
end