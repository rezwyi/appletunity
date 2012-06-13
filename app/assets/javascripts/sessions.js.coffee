$ ->
	$('a#login').click (e)->
    e.preventDefault()
    $('#login-form').modal('show')