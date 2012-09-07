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
    "mailto:#{vacancy.contact_email}?subject=#{vacancy.title}"
  end

  # Public: Build title for given vacancy
  #
  # vacancy - Instance of Vacancy (required)
  #
  # Examples
  #
  #   title_for(vacancy)
  #   # => '[some_vacancy_company_name] some_vacancy title'
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
  # options - The Hash of html options (optional)
  #
  # Examples
  #
  #   logo_for(vacancy)
  #   # => 'img tag'
  #
  # Returns html safe String
  def logo_for(vacancy, size = :small, options = {})
    return unless vacancy
    
    if vacancy.logo?
      html = image_tag(vacancy.logo.url(size), options)
    else
      html = image_tag('no_logo.png', options)
    end
    
    html
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

    url = vacancy_url(vacancy)
    
    case network
    when :twitter then
      via = 'appletunity'
      hash_tags = "##{via}"
      text = "#{title_for(vacancy)} #{url} #{hash_tags}"

      uri = URI.parse 'https://twitter.com/share'
      uri.query = URI.encode_www_form :via => via, :text => text

      uri.to_s.html_safe
    when :facebook then
      uri = URI.parse 'https://facebook.com/sharer/sharer.php'
      uri.query = URI.encode_www_form :u => url
    when :gplus then
      uri = URI.parse 'https://plus.google.com/share'
      uri.query = URI.encode_www_form :url => url
    end

    uri.to_s.html_safe if uri
  end
end
