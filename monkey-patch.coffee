
fs = require "fs"
file = require.resolve "nw-builder/lib/downloader.js"

js = fs.readFileSync file, "utf8"
js = js.replace "var ncp = require('graceful-ncp').ncp;", "var ncp = require('cpr');"
fs.writeFileSync file, js, "utf8"
