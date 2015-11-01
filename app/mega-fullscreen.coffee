
gui = require "nw.gui"

Screen = gui.Screen.Init?() ? gui.Screen

win = gui.Window.get()

win.__proto__.enterMegaFullscreen = ->
	
	do mega_fullscreen = =>
		
		min_x = +Infinity
		min_y = +Infinity
		max_x = -Infinity
		max_y = -Infinity
		
		for screen in Screen.screens
			min_x = Math.min min_x, screen.bounds.x
			min_y = Math.min min_y, screen.bounds.y
			max_x = Math.max max_x, screen.bounds.x + screen.bounds.width
			max_y = Math.max max_y, screen.bounds.y + screen.bounds.height
		
		win.x = min_x
		win.y = min_y
		win.width = max_x - min_x
		win.height = max_y - min_y
		
	update_mega_fullscreen = ->
		setTimeout mega_fullscreen, 150
	
	Screen.on "displayBoundsChanged", update_mega_fullscreen
	Screen.on "displayAdded", update_mega_fullscreen
	Screen.on "displayRemoved", update_mega_fullscreen
	# on Windows, if you change the taskbar settings the window will be
	# moved to only one screen (without any of the above events firing)
	win.on "resize", update_mega_fullscreen
