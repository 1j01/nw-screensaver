
# NW Screensaver

A web screensaver built with [nw.js](http://nwjs.io/)
supporting epic multi-monitor fullscreen
with full transparency.

Add as many screensavers as you want.
You can find some cool ones [on the wiki](https://github.com/1j01/nw-screensaver/wiki/Good-Screensavers).

When there's a `<canvas>` (or `<iframe>`) on the page, other elements are automatically hidden.

You can show hidden elements and interact with the page by holding <kbd>Ctrl</kbd>.


## Dev

1. Have `npm` (from [node.js](http://nodejs.org/))

2. Run `npm install` in the project directory (or `npm i`)

3. Run `npm start` in the project directory


## Todo

* Package as a proper Windows screensaver

* Screenshots (or a photo to really show off the dual-screeny goodness)

* Allow local html pages from pasted file paths and from a Browse button

* Disable auto-switching when interacting

* Maybe make the shortcut to interacting be "tap <kbd>Ctrl</kbd> to toggle"
  (that way you can interact with the page while not holding a modifier key which interferes)

* Streamline the settings window / screensaver window flow
  (Maybe even make them into one)


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
