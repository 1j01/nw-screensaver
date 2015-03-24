
class ScreensaverConfigView
	constructor: (n, {title, url}={})->
		
		@element = document.body.appendChild document.createElement "article"
		
		x = @element.appendChild document.createElement "button"
		x.className = "x"
		# x.innerHTML = "<span>✕</span>"
		x.innerHTML = "✕"
		x.onclick = =>
			if localStorage.current is "#{n}"
				localStorage.current = 0 # ??
			unset n, "url"
			unset n, "title"
			# @element.classList.add "removed"
			@element.style.display = "none"
		
		h1 = @element.appendChild document.createElement "h1"
		h1.contentEditable = on
		
		
		h1.innerHTML = title if title?
		
		h1.onkeydown = h1.onkeypress = h1.onkeyrelease = h1.onpaste = h1.oninput = (e)=>
			if e.keyCode is 13
				e.preventDefault() # single line, pretty please?
			set n, "title", h1.innerHTML
		
		if not url?
			@element.classList.add "ephemeral"
			p = @element.appendChild document.createElement "p"
			p.innerText = "Add a new screensaver by pasting a URL here:"
			p.onfocus = => @focus()
			p.onblur = => @blur()
		
		input = @element.appendChild document.createElement "input"
		input.value = url if url
		
		h1.onfocus = => @focus()
		h1.onblur = => @blur()
		input.onfocus = => @focus()
		input.onblur = => @blur()
		
		input.onpaste = input.onchange = =>
			new_url = input.value
			# if @element.classList.contains "ephemeral"
			# 	set "new", "url", new_url
			# 	unset "new", "result"
			# else
			# @TODO: add http:// protocol if missing
			set n, "url", new_url
			localStorage.current = n
			@element.classList.remove "ephemeral"
		
		input.onkeydown = input.onkeypress = =>
			input.classList.remove "error"
	
	focus: -> @element.classList.add "focus"
	blur: -> @element.classList.remove "focus"


do load = ->
	n = 0
	loop
		url = get n, "url"
		title = get n, "title"
		if url?
			new ScreensaverConfigView n, {title, url}
		else
			new ScreensaverConfigView n
			break
		n++

