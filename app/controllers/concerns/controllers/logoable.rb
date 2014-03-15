module Controllers::Logoable
  extend ActiveSupport::Concern
  
  included do
    before_action do
      if (logo_id = params[:attached_logo_id]).present? && @resource.respond_to?(:build_logoable)
        @resource.build_logoable logo_id: logo_id
      end
    end
  end
end