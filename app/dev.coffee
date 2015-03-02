
window.CRASHED = false

if process?
	nwgui = require 'nw.gui'
	nwwin = nwgui.Window.get()
	
	# Get rid of the shitty broken error handler
	process.removeAllListeners "uncaughtException"
	
	# Add our own handler
	process.on "uncaughtException", (e)->
		console?.warn? "CRASH" unless window.CRASHED; window.CRASHED = true
		nwwin.showDevTools() unless nwwin.isDevToolsOpen()
		nwwin.show() if nwgui.App.manifest.window?.show is false
	
	# Live reload
	try
		chokidar = require 'chokidar'
		watcher = chokidar.watch('.', ignored: /node_modules|\.git/)
		watcher.on 'change', (path)->
			watcher.close()
			console.log 'change', path
			nwwin.closeDevTools()
			location?.reload()
	catch e
		console.warn "Live reload error:", e.stack
	
	window.addEventListener "keydown", (e)->
		if e.keyCode is 123 # F12
			if nwwin.isDevToolsOpen()
				nwwin.closeDevTools()
			else
				nwwin.showDevTools()

window.onerror = (e)->
	console?.warn? "CRASH" unless window.CRASHED; window.CRASHED = true
	console?.error? "Got exception:", e
