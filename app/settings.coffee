
E = ReactScript

ephemeralID = guid()

class ScreensaverConfig extends React.Component
	constructor: ->
		@state = focus: no, urlError: no
	render: ->
		{id, title, url, ephemeral} = @props
		
		setURL = (new_url)=>
			
			if new_url and (new_url.indexOf "://") is -1
				if new_url.match /^(\/|[A-Z]:(\\|\/))/i
					new_url = "file:///#{new_url.replace /^\//, ""}"
				else
					new_url = "http://#{new_url}"
			
			if @props.ephemeral
				ephemeralID = guid()
				add_ss {id, title, url: new_url}
			else
				ss_set id, "url", new_url
			
			set "current", id
			
			render()
		
		active = (get "current") is id
		focus = @state?.focus
		
		E "article.screensaver",
			class: {ephemeral, active, focus}
			
			unless ephemeral
				E "button.x",
					onClick: -> render remove_ss id
					"╳"
			
			unless ephemeral
				E "h1", E "input",
					onFocus: => @focus()
					onBlur: => @blur()
					onChange: (e)=> render ss_set id, "title", e.target.value
					value: title
			else
				E "p", "Add a new screensaver by pasting a URL here:"
			
			E "input",
				key: "url-input"
				class: {error: @state.urlError}
				value: url
				onChange: (e)=> setURL e.target.value
				onPaste: (e)=> setURL e.target.value
				onKeyPress: (e)=> @setState urlError: no
				onKeyDown: (e)=> @setState urlError: no
				onFocus: => @focus()
				onBlur: => @blur()
	
	focus: ->
		@setState focus: yes
		if @props.url
			set "current", @props.id
			render()
	
	blur: ->
		@setState focus: no

class Settings extends React.Component
	render: ->
		sscfgs =
			for scr in get "screensavers"
				scr.key = scr.id
				E ScreensaverConfig, scr
		
		sscfgs.push E ScreensaverConfig,
			key: ephemeralID
			id: ephemeralID
			ephemeral: yes
		
		E ".settings",
			E "section.cycling",
				E "article",
					E "label",
						E "input",
							type: "checkbox",
							checked: get "switch_interval_enabled"
							onChange: (e)->
								set "switch_interval_enabled", e.target.checked
								render()
						" Cycle through screensavers"
					E "label",
						" every "
						E "input",
							type: "number"
							value: (get "switch_interval") ? 30 # FIXME: duplicated default
							onChange: (e)->
								set "switch_interval", e.target.value
								render()
						" seconds"
			E "section.screensavers", sscfgs

do render = ->
	React.render (E Settings), document.body

window.addEventListener "storage", render

window.addEventListener "keydown", (e)-> set "interact", e.ctrlKey
window.addEventListener "keyup", (e)-> set "interact", e.ctrlKey

window.addEventListener "dragover", (e)-> e.preventDefault()
window.addEventListener "dragenter", (e)-> e.preventDefault()
window.addEventListener "drop", (e)-> e.preventDefault()

