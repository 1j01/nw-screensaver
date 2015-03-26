
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

current = 0

window.addEventListener "message", (e)->
	console.log "Received title:", e.data.title

switch_later_tid = null
switch_later = ->
	clearTimeout switch_later_tid
	console.log "I'll switch later"
	switch_later_tid = setTimeout ->
		console.log "win_hidden=#{win_hidden}"
		unless win_hidden
			console.log "Current is #{current}"
			next = Number(current) + 1
			console.log "Next up is #{next}"
			unless get next, "url"
				console.log "Actually that url is #{get next, "url"}, so..."
				next = 0
				console.log "Next up is #{next}"
			unless "#{next}" is "#{current}"
				console.log "Next url is #{get next, "url"}"
				if get next, "url"
					localStorage.current = next
					updateURL()
	, 1000 * 30

wv.addEventListener "contentload", ->
	fn = ->
		window.addEventListener "message", (e)->
			respond = (data)-> e.source.postMessage data, e.origin
			
			if e.data.command is "getTitle"
				respond title: document.title
	
	wv.executeScript code: "(#{fn})()"
	
	# wv.contentWindow???.postMessage command: "getTitle", "*"
	
	wv.insertCSS code: "
		* {
			background: transparent !important;
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
	current = localStorage.current ? 0
	url = get current, "url"
	console.log "Update to #{url} at #{current}?"
	if url isnt last_url
		console.log "Yes!"
		wv.src = last_url = url
		localStorage.current = "skunk rabbit"
		localStorage.current = current
	else
		console.log "No!"

window.addEventListener "storage", updateURL


win.enterMegaFullscreen()


do handle_arguments = ->
	
	show_settings = ->
		global.settings_window ?= nwgui.Window.open "settings.html",
			"title": "Screensaver Settings"
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
			do ->
		else
			# Show the Settings dialog box.
			show_settings()


do exit_upon_input = ->
	
	exit = (event)->
		process.exit() unless win.isDevToolsOpen() or global.settings_window
	
	exit_distance = 30
	start = null
	track = (event)->
		start ?= event
		dx2 = (start.clientX - event.clientX) ** 2
		dy2 = (start.clientY - event.clientY) ** 2
		exit() if dx2 + dy2 >= exit_distance ** 2
	
	hit = (event)->
		event.preventDefault()
		if global.settings_window
			global.settings_window.minimize()
			hide()
		else
			exit()
	
	window.addEventListener "mousemove", track
	window.addEventListener "mousedown", hit
	window.addEventListener "touchstart", hit
	window.addEventListener "keypress", exit
	window.addEventListener "keydown", exit
	window.addEventListener "click", hit

