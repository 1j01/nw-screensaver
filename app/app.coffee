
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
	setTimeout -> # but...
		win.setShowInTaskbar no # now it does
	, 50 # idk
	switch_later()

hide = ->
	win.hide()
	win_hidden = yes
	global.settings_window?.setAlwaysOnTop no



wv = window.wv = document.body.appendChild document.createElement "webview"
wv.allowtransparency = on

current = first_ss()

window.addEventListener "message", (e)->
	console.log "Received title:", e.data.title
	# hopefully, current won't change before we recieve the title
	current_title = ss_get current, "title"
	console.log "Current title:", JSON.stringify current_title
	# @TODO: replace title as long as it's marked as auto
	if (current_title is "Error") or (not current_title)
		ss_set current, "title", e.data.title

switch_later_tid = null
switch_later = ->
	# hack to run in the right context?
	setTimeout ->
		switch_interval_seconds = (get "switch_interval") ? 30 # FIXME: duplicated default
		clearTimeout switch_later_tid
		console.log "I'll switch later"
		switch_later_tid = setTimeout ->
			console.log "win_hidden=#{win_hidden}"
			if get "switch_interval_enabled"
				unless win_hidden
					console.log "Current is #{current}"
					next = next_ss_after current
					console.log "Next up is #{next}"
					unless ss_get next, "url"
						console.log "Actually that url is #{ss_get next, "url"}, so..."
						next = first_ss()
						console.log "Next up is #{next}"
					unless next is current
						console.log "Next url is #{ss_get next, "url"}"
						if ss_get next, "url"
							set "current", next
							updateURL()
		, 1000 * switch_interval_seconds

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
		iframes = document.querySelectorAll "iframe"
		
		isBigEnough = (element)->
			style = getComputedStyle element
			parseInt(style.width) * parseInt(style.height) > 300 * 300
		
		importantStuff = (canvas for canvas in canvases when isBigEnough canvas)
		importantStuff = (iframe for iframe in iframes when isBigEnough iframe) if importantStuff.length is 0
		
		if importantStuff.length
			for el in document.querySelectorAll "*"
				el.classList.add "nw-screensaver-hidden"
				el.classList.remove "nw-important-stuff"
			for importantElement in importantStuff
				el = importantElement
				el.classList.add "nw-important-stuff"
				while el
					el.classList.remove "nw-screensaver-hidden"
					el.classList.add "nw-important-stuff-inside"
					el = el.parentElement
	
	wv.executeScript code: "(#{page_context_fn})()"
	
	wv.contentWindow.postMessage command: "get title", wv.src
	
	wv.contentWindow.postMessage
		command: "settings open"
		settings_open: global.settings_window?
		wv.src
	
	sendInteraction (get "interact")
	
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
		body:not(.nw-screensaver-interact) .nw-important-stuff,
		body:not(.nw-screensaver-interact) .nw-important-stuff-inside {
			position: absolute !important;
			left: 0 !important;
			top: 0 !important;
			right: 0 !important;
			bottom: 0 !important;
			width: 100% !important;
			height: 100% !important;
			padding: 0 !important;
			margin: 0 !important;
			border: 0 !important;
			outline: 0 !important;
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

window.addEventListener "storage", -> sendInteraction (get "interact")
window.addEventListener "keydown", (e)-> sendInteraction e.ctrlKey
window.addEventListener "keyup", (e)-> sendInteraction e.ctrlKey

wv.addEventListener "loadabort", ->
	unless wv.src.match /error\.html/
		wv.src = "error.html"
	switch_later()

last_url = null
do updateURL = ->
	current = (get "current") ? first_ss()
	url = ss_get current, "url"
	unless url
		current = first_ss()
		url = ss_get current, "url"
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
		unless win.isDevToolsOpen() or global.settings_window
			# process.exit() sends "exit" events and then calls process.reallyExit()
			# process.reallyExit() closes the window (with an animation), leaving you on a blank grey non-desktop for a second
			nwgui.App.quit() # freezes the window for as long before exiting immediately (without an animation, which is fine)
			# this is not ideal; why does it take so long to close?
	
	exit_distance = 30
	start = null
	track = (event)->
		return if get "interact"
		if event.ctrlKey
			start = event
		else
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

