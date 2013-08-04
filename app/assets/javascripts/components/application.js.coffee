$ ->
  Application = flight.component ->
    @defaultAttrs
      flashSelector: '.flash'
    
    @after 'initialize', ->
      @select('flashSelector').animate right: '30px'
      setTimeout (=> @select('flashSelector').animate(right: '-1000px')), 5000

  Application.attachTo 'body'