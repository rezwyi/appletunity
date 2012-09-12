module ApplicationHelper
  # Public: Calclutate range of years
  #
  # options - The options Hash (default: {}):
  #           :from - The first year of the range (default: 2012)
  #           :to - The last year of the range (default: <current year>)
  #
  # Examples
  #
  #   copyright_years
  #   # => '2012'
  #
  #   copyright_years(:to => 2015)
  #   # => '2012-2015'
  #
  # Returns html safe String
  def copyright_years(options={})
    options = {:from => 2012, :to => Date.current.year}.merge(options)
    
    if options[:to].to_i <= options[:from].to_i
      html = "#{options[:from]}"
    else
      html = "#{options[:from]}-#{options[:to]}"
    end

    html.html_safe
  end
end
