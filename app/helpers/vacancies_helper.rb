module VacanciesHelper
  include ActionView::Helpers::TagHelper

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
    "mailto:#{vacancy.contact_email}?subject=#{vacancy.title}".html_safe
  end

  # Public: Build title for given vacancy
  #
  # vacancy - Instance of Vacancy (required)
  #
  # Examples
  #
  #   title_for(vacancy)
  #   # => 'some_vacancy_company_name » some_vacancy title'ß
  #
  # Returns html safe String
  def title_for(vacancy)
    return unless vacancy
    ["[#{vacancy.company_name}]", vacancy.title].join(' ').html_safe
  end

  # Public: Build vacancy logo image tag
  #
  # vacancy - Instance of Vacancy (required)
  # size - The size of image attachment (default: :small)
  #
  # Examples
  #
  #   logo_for(vacancy)
  #   # => 'img tag'
  #
  # Returns html safe String
  def logo_for(vacancy, size = :small)
    return unless vacancy

    html = vacancy.logo? ?
      image_tag(vacancy.logo.url(size), alt: vacancy.company_name) :
      image_tag('no_logo.png', alt: vacancy.company_name)
    
    if vacancy.company_website.present?
      html = link_to(html, format_website_url_for(vacancy), data: {'skip-pjax' => ''}, target: '_blank')
    end
    
    content_tag(:div, content_tag(:div, html, class: 'logo-container'), class: 'company-logo')
  end

  # Public: Build share link for the given network name and vacancy instance.
  #         When unknown network name given returns nil.
  #
  # network - The network name Symbol (required):
  #           :twitter
  #           :facebook
  #           :gplus (google plus)
  # vacancy - Instance of Vacancy (required)
  #
  # Examples
  #
  #   build_share_link_for(:twitter, vacancy)
  #   # => 'https://twitter.com/share?...'
  #
  #   build_share_link_for(:unknown, vacancy)
  #   # => nil
  #
  # Returns html safe String
  def build_share_link_for(network, vacancy)
    return unless network && vacancy

    url = vacancy_url(vacancy, utm_source: network.to_s, utm_medium: 'referral', utm_campaign: Date.today.strftime('%b').downcase)
    
    case network
    when :twitter then
      uri = URI.parse 'https://twitter.com/share'
      uri.query = URI.encode_www_form(text: title_for(vacancy), url: url, hashtags: 'appletunity', via: 'appletunity')
      uri.to_s.html_safe
    when :facebook then
      uri = URI.parse 'https://facebook.com/sharer/sharer.php'
      uri.query = URI.encode_www_form u: url
    when :gplus then
      uri = URI.parse 'https://plus.google.com/share'
      uri.query = URI.encode_www_form url: url
    end

    uri.to_s.html_safe if uri
  end

  # Public: Build new VacancyOccupation for each unchecked occupations
  #         of vacancy
  #
  # vacancy - Instance of Vacancy (required)
  #
  # Examples
  #
  #   setup_occupations_for(vacancy)
  #   # => nil
  #
  # Returns sorted array of vacancy.vacancies_occupations
  def setup_vacancies_occupations_for(vacancy)
    (Occupation.all - vacancy.occupations).each do |occupation|
      vacancy.vacancies_occupations.build occupation: occupation
    end
    vacancy.vacancies_occupations.sort { |a,b| b.occupation_id <=> a.occupation_id }
  end

  # Public: Fix company website url
  #
  # vacancy - Instance of Vacancy (required)
  #
  # Examples
  #   
  #   vacancy.company_website = nil
  #   fomat_website_url(vacancy)
  #   # => nil
  #
  #   vacancy.company_website = 'bad website'
  #   fomat_website_url(vacancy)
  #   # => nil
  #
  #   vacancy.company_website = 'example.com'
  #   fomat_website_url(vacancy)
  #   # => "http://example.com"
  #
  # Returns company website url started with http(s)://
  def format_website_url_for(vacancy)
    return unless vacancy && vacancy.company_website
    
    url = URI(vacancy.company_website).to_s
    url = "http://#{url}" unless url.start_with?('http')
    
    url
  rescue URI::InvalidURIError
  end
end