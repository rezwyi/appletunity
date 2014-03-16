#= require jquery
#= require jquery_ujs
#= require plugins/redactor
#= require plugins/redactor.locale

# Boot up admin
$ -> window.Admin = new Appletunity.Admin()

@Appletunity = {}

Appletunity.Admin = ->
  $document = $(document)
  baseNode = $(document.body)
  
  selectors =
    redactorInput: ':input[data-redactor]'
    flash: '#flash'

  init = ->
    if (flashNode = @find(selectors.flash)).length
      flashNode.animate right: '30px'
      setTimeout (-> flashNode.animate(right: '-100%', -> @remove())), 5000

    if (redactorInputNode = @find(selectors.redactorInput))
      redactorInputNode.redactor
        lang: 'ru'
        autoresize: false
        buttons: ['formatting', '|', 'bold', 'italic', 'deleted', '|', 'unorderedlist', 'orderedlist']

  removeErrorsAndBubbles = ->
    baseNode
      .find('.control-group.error').removeClass('error').end()
      .find('.bubble.error').remove()
  
  init.apply $document

  {}