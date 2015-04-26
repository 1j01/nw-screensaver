
# NW Screensaver

A web screensaver built with [nw.js](http://nwjs.io/)
supporting multi-monitor fullscreen
with full transparency

Controls and such are automatically hidden if there's a canvas on the page

You can show hidden elements and interact with the screensaver with <kbd>Ctrl</kbd>


## Dev

1. Have `npm` (from [node.js](http://nodejs.org/) or [io.js](http://iojs.org/))

2. Run `npm install` in the project directory (or `npm i`)

3. Run `npm start` in the project directory


## Todo

* Package as a distributable installer

* Screenshots

* Allow local html pages from pasted file paths and from a Browse button

* Hide controls on things like Codepen
  (maybe if there's no canvas but there's an iframe, present the iframe as above)
  (also, set allowtransparency)

* Shortcut to temporarily show all elements and allow interaction with the page


* Automatic offline support?
  (Maybe some crazy hack
  forcefully setting the <html manifest> attribute
  to load a CACHE MANIFEST that specifies everything stuff to be cached?)
  Maybe try to hook into chromes Save Webpage functionality...


* Some cool integration ideas:
  * Make screen bounds available to the webpage,
    so it can make stuff bounce around off them.
  * Give windows depth in a 3d scene
  * Let webpages access screen captures, use for
    * Env maps in a 3d scene
    * Screensavers involving transformations of the desktop
      * The classic "Sience" screensaver
      * Something with smearing
      * Something with folding
    * Things that bounce around on the screen,
      interacting not simply with the bounds
      but with the contents of the screen.

