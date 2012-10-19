_gaq = _gaq || []
_gaq.push ['_setAccount', 'UA-24462942-2']
_gaq.push ['_trackPageview']

->
  ga = document.createElement 'script'
  ga.type = 'text/javascript'
  ga.async = true

  proto = (document.location.protocol == 'https:' ? 'https://ssl' : 'http://www')
  ga.src = "#{proto}.google-analytics.com/ga.js"
  
  s = document.getElementsByTagName 'script'
  s[0].parentNode.insertBefore ga, s