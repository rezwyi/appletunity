class BetterFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Context, ActionView::Helpers::TagHelper
  include FrontendHelper
  
  def spinner_button(*args)
    @template.spinner_button_tag *args
  end

  def spinner_file_field(*args)
    html_options = args.extract_options!
    value = args[0]
    title = args[1] || I18n.t('ui.buttons.choose_file')
    css_class = concat_css_class('input file', html_options.delete(:class))
    
    content_tag :div, class: css_class, data: {disable_with: spinner} do
      content_tag(:span, title) << @template.file_field(@object_name, value, html_options)
    end
  end
end