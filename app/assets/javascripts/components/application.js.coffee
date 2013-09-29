$ ->
  Application = flight.component ->
    @defaultAttrs
      flashSelector: '.flash'
      remoteForms: 'form[data-remote="true"]'
    
    @after 'initialize', ->
      @select('flashSelector').animate right: '30px'
      setTimeout (=> @select('flashSelector').animate(right: '-1000px')), 5000

      @select('remoteForms').on 'ajax:beforeSend', (event) =>
        $(event.target).find('.control-group.error').removeClass('error').end()
          .find('.bubble.error').remove()
      
      @select('remoteForms').find(':input').on 'change keyup', (event) =>
        $(event.target).parents('.error').removeClass('error')
      
      @select('remoteForms').on 'ajax:success', (event) =>
        event.preventDefault()
        window.location = '/'
      
      @select('remoteForms').on 'ajax:error', (event, xhr) =>
        form = $(event.target)
        errors = JSON.parse(xhr.responseText).errors
        
        for fieldName, error of errors
          target = form.find('*[name*="' + fieldName + '"]')
          targetParent = target.parents('.control-group').addClass('error')

          target = if target.is('textarea:hidden')
            target.parents('.redactor_box')
          else if target.is(':checkbox')
            target.parents('.checkbox')
          else
            target

          @showBubbledText
            insertAfter: targetParent.find('.controls, .redactor_box, .terms')
            target: target
            text: error[0]
            cssClass: 'error'
            beforeShow: (bubble) =>
              if (targetTop = target.offset().top) < $(document).scrollTop()
                $('body, html').animate scrollTop: parseFloat(bubble.css('top')) - 30, 700, =>
                  target.focus()
              else
                target.focus()
          
          break

    @showBubbledText = (options = {}) ->
      bubble = $('<div class="bubble">')
      target = options.target
      targetCoords = target.offset()
      
      if options.cssClass && options.cssClass.length
        bubble.addClass options.cssClass
      
      bubble.html($('<span>').html(options.text))
        .insertAfter(options.insertAfter)
        .css(top: targetCoords.top - bubble.outerHeight() - 50, left: targetCoords.left)

      options.beforeShow(bubble) if typeof(options.beforeShow) is 'function'
      
      bubble.animate(top: '+=35', opacity: '1.0', 150)

      setTimeout ->
        bubble.animate top: '-=35', opacity: '0', 150, -> @remove()
      , options.text.length * 72

  Application.attachTo 'body'