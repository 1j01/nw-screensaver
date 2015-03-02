
nwgui = require "nw.gui"
{screens} = nwgui.Screen.Init()
win = window.win = nwgui.Window.get()



win_hidden = no

show = ->
	win_hidden = no
	global.settings_window?.setAlwaysOnTop yes
	win.show()
	win.setTransparent yes
	win.setVisibleOnAllWorkspaces yes
	win.setShowInTaskbar no # this doesn't work consistently
	setTimeout -> # so... yeah
		win.setShowInTaskbar no # now it does
	, 50 # idk

hide = ->
	win.hide()
	win_hidden = yes
	global.settings_window?.setAlwaysOnTop no



wv = window.wv = document.body.appendChild document.createElement "webview"
wv.allowtransparency = on

wv.addEventListener "contentload", ->
	console.log "contentload", wv.src
	wv.insertCSS code: "
		* {
			background: transparent !important;
		}
	"
	# waiting a tenth of a second means the window won't
	# occasionally appear for a split second as a default-sized opaque
	# (but borderless) window in the top left corner when starting up
	setTimeout show, 100

wv.addEventListener "loadabort", ->
	console.log "loadabort"
	unless wv.src.match /error.html/
		wv.src = "error.html"
		

do updateURL = ->
	wv.src = localStorage["url"] ?= "http://isaiahodhner.ml/pipes/"
	console.log wv.src

window.addEventListener "storage", updateURL



do mega_fullscreen = ->
	
	bounds =
		min_x: +Infinity
		min_y: +Infinity
		max_x: -Infinity
		max_y: -Infinity

	for screen in screens
		bounds.min_x = Math.min bounds.min_x, screen.bounds.x
		bounds.min_y = Math.min bounds.min_y, screen.bounds.y
		bounds.max_x = Math.max bounds.max_x, screen.bounds.x + screen.bounds.width
		bounds.max_y = Math.max bounds.max_y, screen.bounds.y + screen.bounds.height

	win.x = bounds.min_x
	win.y = bounds.min_y
	win.width = bounds.max_x - bounds.min_x
	win.height = bounds.max_y - bounds.min_y



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
		
		console.log global.sw = global.settings_window
		console.log global.settings_window.focus
		global.settings_window.setAlwaysOnTop yes
		global.settings_window.on "close", ->
			nwgui.App.quit()
		global.settings_window.on "focus", ->
			if win_hidden
				show()
				global.settings_window.focus()
			
		#global.settings_window.focus()
	
	console.log nwgui.App.argv, nwgui.App
	switch nwgui.App.argv[0].toLowerCase()
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
			do ->



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
	
	press = (event)->
		event.preventDefault()
		if global.settings_window
			global.settings_window.minimize()
			hide()
		else
			exit()
	
	window.addEventListener "mousemove", track
	window.addEventListener "mousedown", press
	window.addEventListener "touchstart", press
	window.addEventListener "keypress", exit
	window.addEventListener "keydown", exit
	window.addEventListener "click", press

