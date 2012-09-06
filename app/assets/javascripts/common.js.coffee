$(document).ready ->
  # By javascript enable hide the filter
  if $.cookie('_appletunity_hide_filter')
    $('@filter-form').css('margin-top', '-100px')
                     .siblings('@filter-form-switcher').addClass('hidden')

  # Shows the filter
  $('@filter-form-switcher').click (e) ->
    e.preventDefault
    
    that = $(this)
    form = $(this).siblings('form')

    if form.css('margin-top') != '0px'
      form.animate marginTop: '0px'
      $.removeCookie '_appletunity_hide_filter', {path: '/'}
    else
      form.animate marginTop: '-100px'
      $.cookie '_appletunity_hide_filter', true, {path: '/'}

    that.toggleClass 'hidden'