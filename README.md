
# NW Screensaver

A web screensaver platform built with [nw.js](http://nwjs.io/)
supporting epic multi-monitor fullscreen
and transparency.

Add as many screensavers as you want.
You can find some cool ones [on the wiki](https://github.com/1j01/nw-screensaver/wiki/Good-Screensavers).

<!-- Unimportant elements of the page are automatically hidden,
and interesting visual elements brought to fullscreen. 
(with some simple heuristics) -->
<!-- The important content of a page is automatically brought center-stage and made fullscreen,
with all the distractions around it hidden. -->
When there's a `<canvas>` on the page, other elements are automatically hidden.
It'll also look for an `<iframe>` and fullscreen that in order to support
jsfiddles, waybackmachine etc.

You can show hidden elements and interact with the page by holding <kbd>Ctrl</kbd>.


## Install and Run

There's no simple `scr` download yet, so these instructions are really for development:

1. Install [Node.js](http://nodejs.org/) if you don't have it already (it comes with `npm`)
2. [Clone the repo](https://help.github.com/articles/cloning-a-repository/)
3. Open up a command prompt or terminal in the repo directory
4. Run `npm install` or `npm i` to install
5. Run `npm start` to launch it

## Todo

* Windows screensaver
  - Auto-update (try to use nwjs-autoupdater)
  - Exit faster (I think the lag might be fixed since updating nw!)
  - Edit version info for the `scr` file
    (Product Name in particular, as it's used as the name of the screensaver;
    currently the screensaver shows up as "Node.js")
  - Provide download for the `scr` file


* Add some screenshots to this README (or a photo to really show off the dual-screeny goodness; maybe a video?)

* A Browse button for adding local web pages as screensavers

* Disable cycling between screensavers while interacting with one

* Maybe make the shortcut to interacting be "tap <kbd>Ctrl</kbd> to toggle"
  (that way you can interact with the page while not holding a modifier key
  which interferes with some things, like currently you can't scroll because it zooms instead)

* Streamline the settings window / screensaver window flow
  (probably merge the two windows!)


* Per-screensaver setting to disable hiding elements?


* Automatic offline support?
  (Maybe some crazy hack
  like forcefully injecting a service worker to cache pages??
  Or maybe using the [`chrome.webRequest` API](https://developer.chrome.com/extensions/webRequest)?)


* Show thumbnails of screensavers by capturing the image of the page,
  and have a really nice animation/experience for updating it.
  * When you hover over the image, it captures a new thumbnail,
    animates the old up and to the side and smaller (for comparison),
    and lets you click to replace the image.


* Some cool integration ideas (with obvious privacy concerns):
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
