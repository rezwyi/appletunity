class Finder
  def initialize(params = {})
    @params = params
  end

  def retrieve
    vacancies = awaiting_approve ?
      Vacancy.awaiting_approve.group('vacancies.id') :
      Vacancy.live.group('vacancies.id')

    vacancies.order('expired_at desc, id desc').page(page)
  end

  protected

  def method_missing(method, *args, &block)
    @params[method]
  end
end