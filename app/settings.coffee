
###
listeners = []

global.settings =
	listen: (fn)->
		listeners.push fn
	
	get: (item)->
	set: (item, value)->
	
###

#localStorage[""]

class URLInput
	constructor: (url="")->
		input = document.createElement "input"
		input.value = url
		input.onchange = ->
			# add missing protocol
		return input

class ScreensaverConfigView
	constructor: ({title, url}={})->
		article = document.body.appendChild document.createElement "article"
		if title?
			h1 = article.appendChild document.createElement "h1"
			h1.innerText = title
		else
			article.className += "ephemeral";
			p = article.appendChild document.createElement "p"
			p.innerText = "Add a new screensaver by pasting a URL here:"
		input = article.appendChild new URLInput url

new ScreensaverConfigView(title: "Pipes", url: "http://isaiahodhner.ml/pipes/")
new ScreensaverConfigView

###
p = document.body.appendChild document.createElement "p"
p.innerText = ""
document.body.appendChild new URLInput
###

