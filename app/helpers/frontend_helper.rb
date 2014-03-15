module FrontendHelper
	def spinner
    h ['<div class="spinner-button">', %w(one two three four).map { |i| %(<div class="bounce #{i}"></div>) }.join, '</div>'].join
  end
  
  # Public: Concat many css classes into one line
  #
  # Examples
  #
  #   concat_css_class(nil)
  #   # => nil
  #
  #   concat_css_class('css1 css2', 'css3')
  #   # => 'css1 css2 css3'
  #
  #   concat_css_class(' css1 css2 ', 'css3')
  #   # => 'css1 css2 css3'
  #
  # Returns String
  def concat_css_class(*args)
    return if (args = args.compact).length == 0
    args.join(' ').split(' ').uniq.join(' ')
  end

  # Public: Render button tag with animated spinner
  #
  # Examples
  #
  #   spinner_button_tag('Submit')
  #   # => <button data-disable-with="<omitted spinner html>" name="button" type="submit">Submit</button>
  #
  #   spinner_button_tag('Submit', class: 'abtn')
  #   # => <button class="abtn" data-disable-with="<omitted spinner html>" name="button" type="submit">Submit</button>
  #
  # Returns html safe String
  def spinner_button_tag(*args)
    return if (args = args.compact).length == 0
    
    html_options = args.extract_options!
    html_options = {data: {disable_with: spinner}}.merge(html_options)
    value = block_given? ? yield : args[0]
    
    button_tag value, html_options
  end
  
  # Public: Render file field tag with animated spinner
  #
  # Examples
  #
  #   spinner_file_field_tag(:image)
  #   # => <div class="input file" data-disable-with="<omitted spinner html>"><span>Choose file</span><input id="image" name="image" type="file" /></div>
  #
  #   spinner_file_field_tag(:image, 'File', class: 'abtn')
  #   # => <div class="input file abtn" data-disable-with="<omitted spinner html>"><span>File</span><input id="image" name="image" type="file" /></div>
  #
  # Returns html safe String
  def spinner_file_field_tag(*args)
    return if (args = args.compact).length == 0
    
    html_options = args.extract_options!
    value = args[0]
    title = args[1] || t('ui.buttons.choose_file')
    css_class = concat_css_class('input file', html_options.delete(:class))
    
    content_tag :div, class: css_class, data: {disable_with: spinner} do
      content_tag(:span, title) << file_field_tag(value, html_options)
    end
  end
end