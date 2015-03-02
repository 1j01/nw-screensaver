
# NW Screensaver

A web screensaver built with [NW.js](http://nwjs.io/)
supporting multi-monitor fullscreen
with transparency


## Dev

1. Have `npm` (from [node.js](http://nodejs.org/) or [io.js](http://iojs.org/))

2. Run `npm install` in the project directory

3. Run `npm start` in the project directory


## Todo

* Downloads

* Screenshots

* Application Icon

* Handle [Windows screensaver flags](https://support.microsoft.com/kb/182383)

* Configure any URL or local path
  (not from the code, that doesn't count)

* Let you hide elements from the page
  (Things like controls,
  headers and footers,
  other interactive elements...)
  * Presets for things like Codepen
  * Or just dynamically search for canvases
    and by default hide other stuff
    (as long as there's at least one canvas)
  * Shortcut(s?) to temporarily show these elements and allow interaction


* (Automatic?) offline support?
  (Maybe some crazy hack
  forcefully setting the <html manifest> attribute
  to load a CACHE MANIFEST that specifies everything stuff to be cached?)
  Maybe try to hook into chromes Save Webpage functionality...
  Maybe just tell users to download webpages locally with their browser.


