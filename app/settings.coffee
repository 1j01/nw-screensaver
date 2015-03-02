

class URLInput
	constructor: (url="")->
		input = document.createElement "input"
		input.value = url
		input.onchange = ->
			# @TODO: add http:// protocol if missing
			localStorage["url"] = input.value
		return input

class ScreensaverConfigView
	constructor: ({title, url}={})->
		
		@element = document.body.appendChild document.createElement "article"
		
		if title?
			h1 = @element.appendChild document.createElement "h1"
			h1.innerText = title
			h1.contentEditable = on
			h1.onfocus = -> @focus()
			h1.onblur = -> @blur()
		else
			@element.className += "ephemeral"
			p = @element.appendChild document.createElement "p"
			p.innerText = "Add a new screensaver by pasting a URL here:"
			p.onfocus = -> @focus()
			p.onblur = -> @blur()
		
		input = @element.appendChild new URLInput url
		
		input.onfocus = -> @focus()
		input.onblur = -> @blur()
	
	focus: -> console.log "wtf"; @element.classList.add "focus"
	blur: -> console.log "wtf!!!!!"; @element.classList.remove "focus"

new ScreensaverConfigView(title: "Pipes", url: localStorage["url"] ?= "http://isaiahodhner.ml/pipes/")
new ScreensaverConfigView


