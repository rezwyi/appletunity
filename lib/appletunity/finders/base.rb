module Appletunity::Finders
  class Base
    def initialize(params={})      
      @params = normalize_params(params)
    end

    def retrieve
      vacancies = Vacancy.where('expired_at >= ?', Time.now)\
                         .group('vacancies.id')

      if filter
        if keywords
          query = ['title LIKE ?', 'body LIKE ?', 'location LIKE ?',
                   'company_name LIKE ?'].join(' OR ')
          params = "%#{keywords.split(' ').join('%')}%"
          vacancies = vacancies.where(query, params, params, params, params)
        end

        if occupations
          vacancies = vacancies.joins(:occupations)\
                               .where(:occupations => {:id => occupations})
        end
      end

      vacancies.order('id DESC').page(page).per(per_page)
    end

    def keywords
      @keywords ||= filter.try(:[], 'keywords')
    end

    def occupations
      @occupations ||= filter.try(:[], 'occupations')
    end

    def have_occupation?(occupation)
      occupations && occupations.include?(occupation.id.to_s)
    end

    protected

    def method_missing(method, *args, &block)
      @params[method]
    end

    def normalize_params(params)
      params[:per_page] ||= Rails.application.config.default_per_page
      params
    end
  end
end