$ ->
  Application = flight.component ->
    @defaultAttrs
      filterFormSelector: '#filter-form'
      filterFormSwitcherSelector: '.js-filter-form-switcher'
      flashSelector: '.flash'
    
    @after 'initialize', ->
      @select('flashSelector').animate right: '30px'
      setTimeout (=> @select('flashSelector').animate(right: '-1000px')), 5000
      
      if $.cookie('_appletunity_hide_filter')
        @select('filterFormSelector').find('form').css('margin-top', '-100px')
        @select('filterFormSwitcherSelector').addClass('hidden')

      @on 'click',
        filterFormSwitcherSelector: (e) ->
          e.preventDefault()
        
          switcher = $(e.target).toggleClass('hidden')
          form = @select('filterFormSelector').find('form')

          if form.css('margin-top') isnt '0px'
            form.animate marginTop: '0px'
            $.removeCookie '_appletunity_hide_filter', path: '/'
          else
            form.animate marginTop: '-100px'
            $.cookie '_appletunity_hide_filter', true, path: '/'

  Application.attachTo 'body'