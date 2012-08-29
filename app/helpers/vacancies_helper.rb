module VacanciesHelper
  # Public: Build 'mailto' link for given vacancy
  #
  # vacancy - Instance of Vacancy (required)
  #
  # Examples
  #
  #   mailto_for(vacancy)
  #   # => 'mailto:some@email.com?subject=some_title'
  #
  # Returns String
  def mailto_for(vacancy)
    return unless vacancy && vacancy.title && vacancy.contact_email
    "mailto:#{vacancy.contact_email}?subject=#{vacancy.title}"
  end
end
