
gui = require "nw.gui"

Screen = gui.Screen.Init?() ? gui.Screen

win = gui.Window.get()

win.__proto__.enterMegaFullscreen = ->
	
	do mega_fullscreen = =>
		
		bounds =
			min_x: +Infinity
			min_y: +Infinity
			max_x: -Infinity
			max_y: -Infinity
		
		for screen in Screen.screens
			bounds.min_x = Math.min bounds.min_x, screen.bounds.x
			bounds.min_y = Math.min bounds.min_y, screen.bounds.y
			bounds.max_x = Math.max bounds.max_x, screen.bounds.x + screen.bounds.width
			bounds.max_y = Math.max bounds.max_y, screen.bounds.y + screen.bounds.height
		
		win.x = bounds.min_x
		win.y = bounds.min_y
		win.width = bounds.max_x - bounds.min_x
		win.height = bounds.max_y - bounds.min_y
		
	update_mega_fullscreen = ->
		setTimeout mega_fullscreen, 150
	
	Screen.on "displayBoundsChanged", update_mega_fullscreen
	Screen.on "displayAdded", update_mega_fullscreen
	Screen.on "displayRemoved", update_mega_fullscreen
