
nwgui = require "nw.gui"
win = window.win = nwgui.Window.get()

win_hidden = yes

show = ->
	win_hidden = no
	global.settings_window?.setAlwaysOnTop yes
	win.show()
	win.setTransparent yes
	win.setVisibleOnAllWorkspaces yes
	win.setShowInTaskbar no # this doesn't work consistently
	setTimeout -> # so...
		win.setShowInTaskbar no # now it does
	, 50 # idk
	switch_later()

hide = ->
	win.hide()
	win_hidden = yes
	global.settings_window?.setAlwaysOnTop no



wv = window.wv = document.body.appendChild document.createElement "webview"
wv.allowtransparency = on

current = (get "screensavers")[0].id

window.addEventListener "message", (e)->
	console.log "Received title:", e.data.title
	# alert e.data.title
	# hopefully, current won't change before we recieve the title
	# console.log "Current title:", JSON.stringify ssget current, "title"
	# current_title = ssget current, "title"
	# # @TODO: replace title as long as it's marked as auto
	# if (current_title is "Error") or (not current_title)
	# 	ssset current, "title", e.data.title
	# 	# hopefully titles won't contain XSS (actually, let's just get rid of the silly contentEditable titles)

switch_later_tid = null
switch_later = ->
	clearTimeout switch_later_tid
	console.log "I'll switch later"
	switch_later_tid = setTimeout ->
		console.log "win_hidden=#{win_hidden}"
		unless win_hidden
			console.log "Current is #{current}"
			next = nextAfter current
			console.log "Next up is #{next}"
			unless ssget next, "url"
				console.log "Actually that url is #{ssget next, "url"}, so..."
				next = first()
				console.log "Next up is #{next}"
			unless next is current
				console.log "Next url is #{ssget next, "url"}"
				if ssget next, "url"
					set "current", next
					updateURL()
	, 1000 * 30

wv.addEventListener "contentload", ->
	
	page_context_fn = ->
		interact = (interact)->
			if interact
				document.body.classList.add "nw-screensaver-interact"
			else
				document.body.classList.remove "nw-screensaver-interact"
		
		settings_open = (settings_open)->
			if settings_open
				document.body.classList.add "nw-screensaver-settings-open"
			else
				document.body.classList.remove "nw-screensaver-settings-open"
		
		window.addEventListener "keydown", (e)-> interact e.ctrlKey
		window.addEventListener "keyup", (e)-> interact e.ctrlKey
		
		window.addEventListener "message", (e)->
			respond = (data)-> e.source.postMessage data, e.origin
			
			switch e.data.command
				when "get title"
					respond title: document.title
				when "interact"
					interact e.data.interact
				when "settings open"
					settings_open e.data.settings_open
		
		canvases = document.querySelectorAll "canvas"
		canvas = null
		for c in canvases
			canvas ?= c if c.width * c.height > 100 * 100
			canvas = c if c.width * c.height > canvas.width * canvas.height
		
		if canvas
			for el in document.querySelectorAll "*"
				el.classList.add "nw-screensaver-hidden"
			el = canvas
			while el
				el.classList.remove "nw-screensaver-hidden"
				el = el.parentElement
	
	wv.executeScript code: "(#{page_context_fn})()"
	
	wv.contentWindow.postMessage command: "get title", wv.src
	
	wv.contentWindow.postMessage
		command: "settings open"
		settings_open: global.settings_window?
		wv.src
	
	wv.insertCSS code: "
		* {
			background: transparent !important;
		}
		body:not(.nw-screensaver-interact) .nw-screensaver-hidden {
			display: none !important;
		}
		body:not(.nw-screensaver-interact):not(.nw-screensaver-settings-open) {
			cursor: none !important;
		}
	"
	
	# waiting a tenth of a second means the window won't
	# occasionally appear for a split second as a default-sized opaque
	# (but borderless) window in the top left corner when starting up
	setTimeout ->
		if win_hidden
			show()
			global.settings_window?.focus()
	, 100
	
	switch_later()


sendInteraction = (interact)->
	return unless wv.src.match /^http:/
	wv.contentWindow.postMessage
		command: "interact"
		interact: interact
		wv.src

window.addEventListener "storage", ->
	sendInteraction (get "interact")

window.addEventListener "keydown", (e)-> sendInteraction e.ctrlKey
window.addEventListener "keyup", (e)-> sendInteraction e.ctrlKey

# wv.addEventListener "loadstop", ->
# 	console.log "The page has stopped loading."
# 	console.log "Here's the contentWindow:", wv.contentWindow
# 	global.settings_window.console.log "The page has stopped loading."
# 	global.settings_window.console.log "Here's the contentWindow:", wv.contentWindow

wv.addEventListener "loadabort", ->
	unless wv.src.match /error\.html/
		wv.src = "error.html"
	switch_later()

last_url = null
do updateURL = ->
	current = (get "current") ? (get "screensavers")[0].id
	url = ssget current, "url"
	unless url
		current = (get "screensavers")[0].id
		url = ssget current, "url"
	console.log "Update to #{url} at #{current}?"
	if url isnt last_url
		console.log "Yes!"
		wv.src = last_url = url
		set "current", "HACK"
		set "current", current
	else
		console.log "No!"

window.addEventListener "storage", updateURL


win.enterMegaFullscreen()


do handle_arguments = ->
	
	show_settings = ->
		global.settings_window ?= nwgui.Window.open "settings.html",
			"title": "Screensaver Settings"
			"icon": "img/icon.png"
			"toolbar": false
			"transparent": false
			"frame": true
			"resizable": true
			"visible-on-all-workspaces": false
			"always-on-top": false
			"show": true
		
		global.settings_window.setAlwaysOnTop yes
		global.settings_window.on "close", ->
			nwgui.App.quit()
		global.settings_window.on "focus", ->
			if win_hidden
				show()
				global.settings_window.focus()
	
	switch (nwgui.App.argv[0] ? "").toLowerCase()
		when "/c"
			# Show the Settings dialog box, modal to the foreground window.
			show_settings()
		when "/p"
			# Preview Screen Saver as child of window <HWND>.
			process.exit()
		when "/s"
			# Run the Screen Saver.
		else
			# Show the Settings dialog box.
			show_settings()


do exit_upon_input = ->
	
	exit = (event)->
		process.exit() unless win.isDevToolsOpen() or global.settings_window
	
	exit_distance = 30
	start = null
	track = (event)->
		return if get "interact"
		start ?= event
		dx2 = (start.clientX - event.clientX) ** 2
		dy2 = (start.clientY - event.clientY) ** 2
		exit() if dx2 + dy2 >= exit_distance ** 2
	
	hit = (event)->
		return if event.ctrlKey
		event.preventDefault()
		if global.settings_window
			global.settings_window.minimize()
			hide()
		else
			exit()
	
	key = (event)->
		return if event.ctrlKey
		exit()
	
	window.addEventListener "mousemove", track
	window.addEventListener "mousedown", hit
	window.addEventListener "touchstart", hit
	window.addEventListener "keypress", key
	window.addEventListener "keydown", key
	window.addEventListener "click", hit

