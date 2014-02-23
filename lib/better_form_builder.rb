class BetterFormBuilder < ActionView::Helpers::FormBuilder
  def spinner_button(*args)
    html_options = args.extract_options!
    disable_with = [
      '<div class="spinner-button">',
        %w(one two three four).map { |i| %(<div class="bounce #{i}"></div>) }.join,
      '</div>'
    ].join
    
    value = block_given? ? yield : args[0]
    html_options = {data: {disable_with: disable_with}}.merge(html_options)
    
    @template.button_tag value, html_options
  end
end