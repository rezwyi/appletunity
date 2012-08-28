module Appletunity::Finders
  class Base
    def initialize(params)
      @params = {}
      @params = params
    end

    #
    def retrieve
      vacancies = Vacancy.where('expired_at >= ?', Time.now)\
                         .page(page).per(per_page)

      vacancies.order('id DESC')
    end

    protected

    def method_missing(method, *args, &block) 
      @params[method]
    end
  end
end