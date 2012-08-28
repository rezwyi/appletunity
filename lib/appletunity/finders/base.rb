module Appletunity::Finders
  class Base
    def initialize(params)
      @params = {}
      @params = params
    end

    #
    def retrieve
      Vacancy.where('expired_at >= ?', Time.now).page(page).per(per_page)
    end

    protected

    def method_missing(method, *args, &block) 
      @params[method]
    end
  end
end