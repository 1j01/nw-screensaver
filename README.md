
# NW Screensaver

A web screensaver built with [nw.js](http://nwjs.io/)
supporting multi-monitor fullscreen
with full transparency

Controls and such are automatically hidden if there's a canvas on the page

You can show hidden elements and interact with the screensaver with <kbd>Ctrl</kbd>

You can configure as many screensavers as you want


## Dev

1. Have `npm` (from [node.js](http://nodejs.org/) or [io.js](http://iojs.org/))

2. Run `npm install` in the project directory (or `npm i`)

3. Run `npm start` in the project directory


## Todo

* Package as a distributable installer
  (through [NSIS](http://nsis.sourceforge.net/Main_Page)? maybe make an `nsis` package?)

* Screenshots (or a photo to really show off the dual-screeny goodness)

* Wiki page where people can list cool screensaver pages

* Allow local html pages from pasted file paths and from a Browse button

* Automatically grab the title from a page

* Settings to configure the interval or disable switching screensavers

* Disable auto-switching when interacting

* Maybe make the shortcut to interacting be "tap <kbd>Ctrl</kbd> to toggle"
  (that way you can interact with the page while not holding a modifier key which interferes)

* Streamline the settings window / screensaver window flow
  (Maybe even make them into one)

* Hide controls on things like Codepen
  (maybe if there's no canvas but there's an iframe, present the iframe as it would a canvas)
  (also, set allowtransparency)

* Show any canvases that are big enough, not just one
  (some applications use multiple canvases, even as layers)

* Per-screensaver setting to disable hiding elements?


* Automatic offline support?
  (Maybe some crazy hack
  forcefully setting the <html manifest> attribute
  to load a CACHE MANIFEST that specifies everything should be cached??)
  Maybe try to hook into chrome's "Save page as..." functionality...??


* Show thumbnails of screensavers by capturing the image of the page,
  and have a really nice animation/experience for updating it.
  * When you hover over the image, it captures a new thumbnail,
    animates the old up and to the side and smaller (for comparison),
    and lets you click to replace the image.


* Some cool integration ideas:
  * Make screen bounds available to the webpage,
    so it can make stuff bounce around off them.
  * Give windows depth in a 3d scene
  * Let webpages access screen captures, use for
    * Env maps in a 3d scene
    * Screensavers involving transformations of the desktop
      * The classic "Science" screensaver
      * Something with smearing
      * Something with folding
    * Things that bounce around on the screen,
      interacting not simply with the bounds
      but with the contents of the screen.
  * Or, for starters, let webpages access the desktop background
    (with [`wallpaper`](https://www.npmjs.com/package/wallpaper))
