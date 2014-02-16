#= require jquery
#= require jquery_ujs
#= require jquery.pjax
#= require plugins/redactor
#= require plugins/redactor.locale
#= require plugins/nprogress

# Some general setup
if $.support.pjax then $.pjax.defaults.timeout = 0
if NProgress
  NProgress.configure
    showSpinner: false
    template: '<div class="bar" role="bar"><div class="peg"></div></div>'

# Boot up application
$ -> window.Application = new Appletunity.Application()

@Appletunity = {}

Appletunity.Application = ->
  $document = $(document)
  baseNode = $(document.body)
  
  selectors =
    pjaxifiedLink: 'a:not([data-remote]):not([data-method]):not([data-skip-pjax])'
    ajaxifiedForm: 'form[data-remote]'
    redactorInput: ':input[data-redactor]'
    
    flash: '#flash'

  init = ->
    if (flashNode = @find(selectors.flash)).length
      flashNode.animate right: '30px'
      setTimeout (-> flashNode.animate(right: '-100%', -> @remove())), 5000

    # Need to properly reinitialize redactor if present
    if (redactorInputNode = @find(selectors.redactorInput))
      htmlBackup = ''
      
      redactorInputNode.destroyEditor() if redactorInputNode.data('redactor')

      if (redactorBox = @find('.redactor_box'))
        htmlBackup = redactorBox.find('[contenteditable]').html()
        
        redactorInputNode.insertBefore redactorBox
        redactorBox.remove()
      
      redactorInputNode.val(htmlBackup).redactor
        lang: 'ru'
        autoresize: false
        buttons: ['formatting', '|', 'bold', 'italic', 'deleted', '|', 'unorderedlist', 'orderedlist']

  bind = ->
    @on 'ajax:beforeSend pjax:beforeSend', (e) -> $(e.target).on('click.railsDisable', $.rails.stopEverything)
    @on 'ajax:beforeSend', removeErrorsAndBubbles
    @on 'pjax:beforeSend', (e) -> $(e.target).on('click.railsDisable', $.rails.stopEverything)
    @on 'ajax:complete', (e) -> $(e.target).off('click.railsDisable')
    
    @on 'pjax:end', (e, xhr) ->
      removeErrorsAndBubbles()

      # Google Analytics support
      if (window._gaq)
        _gaq.push ['_trackPageview', window.location.href]
      
      # If xhr is null pjax:end was triggered from popstate event and means that
      # page was poped from history
      if xhr isnt null
        $(e.target).off 'click.railsDisable'
        $(@).trigger 'uiPageUpdated'
      else
        $(@).trigger 'uiPageRestored'

    # Every time when pjax link clicked or forward/back button pressed we need
    # to reinit Application. This will correctly reinit plugins and do some stuff
    @on 'uiPageUpdated uiPageRestored', -> init.apply($document)

    # Show progress bar while pjax request is executed
    if $.support.pjax
      @on 'pjax:timeout pjax:beforeSend uiPageRestored', stopProgresBar
      @on 'pjax:beforeSend', NProgress.start
      @on 'uiPageUpdated', showPjaxProgressUntilImagesIsLoaded

    @on 'click', selectors.pjaxifiedLink, (e) ->
      # Fallback to basic click if history API is not supported (e.g. IE9-)
      if $.support.pjax
        e.preventDefault()
        $.pjax.click e, container: $(@).closest('[data-page-container]')
    
    @on 'change keyup', selectors.ajaxifiedForm + ' :input', ->
      $(@).closest('.error').removeClass('error')

    @on 'ajax:success', selectors.ajaxifiedForm, (e, data, status, xhr) ->
      formNode = $(@)
      
      $.rails.enableFormElements formNode

      if (l = xhr.getResponseHeader('Location'))
        $.pjax
          url: l
          container: formNode.closest('[data-page-container]')
          replace: @hasAttribute('data-pjax-replace')

    @on 'ajax:error', selectors.ajaxifiedForm, (e, xhr) ->
      formNode = $(@)
      errors = JSON.parse(xhr.responseText).errors

      $.rails.enableFormElements formNode
      
      for fieldName, error of errors
        targetNode = formNode.find('*[name*="' + fieldName + '"]')
        parentNode = targetNode.parents('.control-group').addClass('error')

        targetNode = if targetNode.is('textarea:hidden')
          targetNode.closest('.redactor_box')
        else if targetNode.is(':checkbox')
          targetNode.closest('.checkbox')
        else
          targetNode

        showBubbledText
          insertAfter: parentNode.find('.controls, .redactor_box, .terms')
          target: targetNode
          text: error[0]
          cssClass: 'error'
          beforeShow: (bubbleNode) ->
            scrollTop = parseFloat(bubbleNode.css('top')) - 30
            
            if targetNode.offset().top < $document.scrollTop()
              $('body, html').animate scrollTop: scrollTop, 700, -> targetNode.focus()
            else
              targetNode.focus()
        
        # Show only one error
        break

  removeErrorsAndBubbles = ->
    baseNode
      .find('.control-group.error').removeClass('error').end()
      .find('.bubble.error').remove()

  showBubbledText = (options = {}) ->
    bubbleNode = $('<div class="bubble">')
    targetNode = options.target
    targetCoords = targetNode.offset()
    
    if options.cssClass && options.cssClass.length
      bubbleNode.addClass options.cssClass
    
    bubbleNode.html($('<span>').html(options.text))
      .insertAfter(options.insertAfter)
      .css(top: targetCoords.top - bubbleNode.outerHeight() - 50, left: targetCoords.left)

    options.beforeShow(bubbleNode) if typeof(options.beforeShow) is 'function'
    
    bubbleNode.animate(top: '+=35', opacity: '1.0', 150)

    setTimeout ->
      bubbleNode.animate top: '-=35', opacity: '0', 150, -> @remove()
    , options.text.length * 72

  stopProgresBar = ->
    NProgress.remove()
    NProgress.status = null

  showPjaxProgressUntilImagesIsLoaded = (e, xhr) ->
    return NProgress.done() unless xhr && xhr.responseText
    
    currentProgress = 0.5
    loadedImages = 0
    imageNodes = $(xhr.responseText).find('img')
    
    if imageNodes.length
      # Set progress to 50% immediately once the pjax request completed
      # then wait until all images is loaded and set progress to 100%
      NProgress.set currentProgress
      imageNodes.each ->
        $(@).imageLoad -> NProgress.done() if ++loadedImages is imageNodes.length
    else
      NProgress.done()

  bind.apply $document
  init.apply $document

  {}