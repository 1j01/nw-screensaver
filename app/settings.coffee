
E = ReactScript

ephemeralID = guid()

class ScreensaverConfig extends React.Component
	constructor: ->
		@state = focus: no, urlError: no
	render: ->
		{id, title, url, ephemeral} = @props
		
		setURL = (new_url)=>
			# @TODO: add http:// protocol if missing
			if @props.ephemeral
				ephemeralID = guid()
				addss {id, title, url: new_url}
			else
				ssset id, "url", new_url
			set "current", id
			render()
		
		active = (get "current") is id
		focus = @state?.focus
		
		E "article",
			class: {ephemeral, active, focus}
			
			unless ephemeral
				E "button.x",
					onClick: -> render removess id
					"✕"
			
			unless ephemeral
				# React.createElement "h1",
					# contentEditable: on
					# dangerouslySetInnerHTML: __html: title ? "" 
				E "h1", E "input",
					onFocus: => @focus()
					onBlur: => @blur()
					onChange: (e)=> render ssset id, "title", e.target.value
					value: title
			else
				E "p", "Add a new screensaver by pasting a URL here:"
			
			E "input",
				class: {error: @state.urlError}
				value: url
				onChange: (e)=> setURL e.target.value
				onPaste: (e)=> setURL e.target.value
				onKeyPress: (e)=> @setState urlError: no
				onKeyDown: (e)=> @setState urlError: no
				onFocus: => @focus()
				onBlur: => @blur()
		
		# x.onclick = =>
		# 	if localStorage.current is "#{n}"
		# 		localStorage.current = 0 # ??
		# 	unset n, "url"
		# 	unset n, "title"
		# 	@element.style.display = "none"
		# 
		# h1 = @element.appendChild document.createElement "h1"
		# h1.contentEditable = on
		# 
		# h1.innerHTML = title if title?
		# 
		# h1.onkeydown = h1.onkeypress = h1.onkeyrelease = h1.onpaste = h1.oninput = (e)=>
		# 	if e.keyCode is 13
		# 		e.preventDefault() # single line, pretty please?
		# 	set n, "title", h1.innerHTML
		# 
		# if not url?
		# 	@element.classList.add "ephemeral"
		# 	p = @element.appendChild document.createElement "p"
		# 	p.innerText = "Add a new screensaver by pasting a URL here:"
		# 	p.onfocus = => @focus()
		# 	p.onblur = => @blur()
		# 
		# input = @element.appendChild document.createElement "input"
		# input.value = url if url
		# 
		# h1.onfocus = => @focus()
		# h1.onblur = => @blur()
		# input.onfocus = => @focus()
		# input.onblur = => @blur()
		# 
		# input.onpaste = input.onchange = =>
		# 	new_url = input.value
		# 	# @TODO: add http:// protocol if missing
		# 	set n, "url", new_url
		# 	localStorage.current = n
		# 	if @element.classList.contains "ephemeral"
		# 		new ScreensaverConfigView n + 1
		# 	@element.classList.remove "ephemeral"
		# 	upd()
		# 
		# input.onkeydown = input.onkeypress = =>
		# 	input.classList.remove "error"
	
	focus: ->
		@setState focus: yes
		if @props.url
			set "current", @props.id
		# @element.classList.add "focus"
		# if @props.url
		# 	set "current", @n
		# upd()
	
	blur: ->
		@setState focus: no
		# @element.classList.remove "focus"
# 
# upd = ->
# 	console.log "storage"
# 	for e in document.querySelectorAll "article"
# 		console.log localStorage.current, e.n
# 		active = localStorage.current is "#{e.n}"
# 		e.classList[if active then "add" else "remove"] "active"

# do load = ->
# 	document.body.innerHTML = ""
# 	n = 0
# 	loop
# 		url = get n, "url"
# 		title = get n, "title"
# 		if url?
# 			new ScreensaverConfigView n, {title, url}
# 		else
# 			new ScreensaverConfigView n
# 			break
# 		n++
# 	do upd

class Settings extends React.Component
	render: ->
		# sscfgs = []
		# n = 0
		# loop
		# 	url = get n, "url"
		# 	title = get n, "title"
		# 	if url?
		# 		sscfgs.push E ScreensaverConfig, {n, title, url}
		# 	else
		# 		sscfgs.push E ScreensaverConfig, {n}
		# 		break
		# 	n++
		
		# E ".settings",
		# 	for scr in get "screensavers"
		# 		scr.key = scr.id
		# 		E ScreensaverConfig, scr
		# 	E ScreensaverConfig, {id: guid(), ephemeral: yes}
		
		sscfgs =
			for scr in get "screensavers"
				scr.key = scr.id
				E ScreensaverConfig, scr
		
		sscfgs.push E ScreensaverConfig, {id: ephemeralID, ephemeral: yes}
		
		E ".settings",
			sscfgs

do render = ->
	React.render (E Settings), document.body

window.addEventListener "storage", render

window.addEventListener "keydown", (e)-> set "interact", e.ctrlKey
window.addEventListener "keyup", (e)-> set "interact", e.ctrlKey

