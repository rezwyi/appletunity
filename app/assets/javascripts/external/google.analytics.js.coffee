# See http://stackoverflow.com/questions/4214731/coffeescript-global-variables
root = exports ? this
root._gaq = [['_setAccount', 'UA-24462942-2'], ['_trackPageview']]

insertGAScript = ->
  ga = document.createElement 'script'
  ga.type = 'text/javascript'
  ga.async = true

  proto = document.location.protocol
  proto = if (proto is 'https:') then 'https://ssl' else 'http://www'
  ga.src = "#{proto}.google-analytics.com/ga.js"
  
  s = document.getElementsByTagName 'script'
  s[0].parentNode.insertBefore ga, s

insertGAScript()