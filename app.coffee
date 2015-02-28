
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
	win.show()
	wv.insertCSS code: "
		* {
			background: transparent !important;
		}
	"


