
nwgui = require "nw.gui"
win = window.win = nwgui.Window.get()
global.screensaver_window = win
# win.showDevTools()

win_hidden = no

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

hide = ->
	win.hide()
	win_hidden = yes
	global.settings_window?.setAlwaysOnTop no



wv = window.wv = document.body.appendChild document.createElement "webview"
wv.allowtransparency = on

current = 0

window.addEventListener "message", (e)->
	console.log "Received title:", e.data.title

wv.addEventListener "contentload", ->
	# console.log wv.document, wv.document?.title
	# unless get current, "title"
	# 	set current, "title", wv.document.title
	fn = ->
		window.addEventListener "message", (e)->
			respond = (data)-> e.source.postMessage data, e.origin
			
			if e.data.command is "getTitle"
				respond title: document.title
	
	wv.executeScript code: "(#{fn})()"
	
	wv.contentWindow?.postMessage command: "getTitle", "*"
	
	wv.insertCSS code: "
		* {
			background: transparent !important;
		}
	"
	
	# waiting a tenth of a second means the window won't
	# occasionally appear for a split second as a default-sized opaque
	# (but borderless) window in the top left corner when starting up
	setTimeout show, 100

trying_new_page = no

wv.addEventListener "loadabort", ->
	# if trying_new_page
	# 	set "new", "url", null
	# 	set "new", "result", "error"
	# else
	unless wv.src.match /error\.html/
		wv.src = "error.html"

last_url = null
do updateURL = ->
	current = localStorage.current ? 0
	url = get current, "url"
	# url = get "new", "url"
	# if url
	# 	trying_new_page = yes
	# else
	# 	trying_new_page = no
	# 	
	# 	url = get current, "url"
	# 	# url = (get "current", "url") ? (get 0, "url")
	# if wv.src isnt url
	if url isnt last_url
		wv.src = last_url = url

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

