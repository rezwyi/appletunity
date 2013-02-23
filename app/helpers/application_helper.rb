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

  # Public: Convert flash key to bootstrap class
  #
  # Examples
  #
  #   bootstrapize_flash_key(:message)
  #   # => 'alert-success'
  #
  # Returns html safe String
  def bootstrapize_flash_key(key)
    return unless key

    css_class = case key
    when :message
      'alert-success'
    when :notice
      'alert-success'
    when :error
      'alert-error'
    when :alert
      'alert-error'
    end

    css_class.try(:html_safe)
  end

  # Public: Generate title and meta tags related to current controller
  #
  # Returns html safe String
  def title_and_metas
    output = ''
    ivar = instance_variable_get("@#{controller_name.singularize}")

    title = content_tag(
      :title,
      [t(:appletunity), t(:best_vacancies)].join(' - ')
    )

    image = tag(:meta,
      :property => 'og:image',
      :content => image_path('appletunity.png')
    )

    meta = {'description' => t(:intro)}

    if ivar
      if ivar.respond_to?(:title) && ivar.title.present?
        title = content_tag(
          :title,
          [t(:appletunity), ivar.company_name, ivar.title].join(' - ')
        )
      end

      if ivar.respond_to?(:logo) && ivar.respond_to?(:logo?)
        image = tag(:meta,
          :property => 'og:image',
          :content => ivar.logo.to_s
        ) if ivar.logo?
      end

      if ivar.respond_to?(:body) && ivar.body.present?
        meta['description'] = truncate(strip_tags(ivar.body), :length => 200)
      end
    end

    output << [title, image].join("\n") << "\n"
    output << meta.map { |k,v| tag(:meta, :name => k, :content => v) }.join("\n")

    output.html_safe
  end
end
