
nwgui = require "nw.gui"
{screens} = nwgui.Screen.Init()
win = window.win = nwgui.Window.get()
wv = window.wv = document.querySelector "webview"

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


wv.addEventListener "contentload", ->
	wv.insertCSS code: "
		* {
			background: transparent !important;
		}
	"
	# waiting a tenth of a second means the window won't
	# occasionally appear for a split second as a default-sized opaque
	# (but borderless) window in the top left corner when starting up
	setTimeout ->
		win.show()
	, 100


exit = (event)->
	process.exit() unless win.isDevToolsOpen()

min_dist_mouse_moved_to_exit = 30
start = null
track = (event)->
	start ?= event
	dx2 = (start.clientX - event.clientX) ** 2
	dy2 = (start.clientY - event.clientY) ** 2
	exit() if dx2 + dy2 >= min_dist_mouse_moved_to_exit ** 2

window.addEventListener "mousemove", track
window.addEventListener "mousedown", exit
window.addEventListener "touchstart", exit
window.addEventListener "keypress", exit
window.addEventListener "keydown", exit
window.addEventListener "click", exit

