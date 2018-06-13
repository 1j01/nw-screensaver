
fs = require "fs"

writeFileAndLog = (path, contents)->
	fs.writeFileSync path, contents, "utf8"
	console.log "[monkey-patch.coffee] patched #{path}"

nwDownloaderFile = require.resolve "nw-builder/lib/downloader.js"

js = fs.readFileSync nwDownloaderFile, "utf8"
js = js.replace "var ncp = require('graceful-ncp').ncp;", "var ncp = require('cpr'); // line replaced by nw-screemsaver's monkey-patch.coffee"

writeFileAndLog nwDownloaderFile, js

for moduleName in ["pump", "uuid"]
	packageJSON = require.resolve "#{moduleName}/package.json"

	json = fs.readFileSync packageJSON, "utf8"
	pkg = JSON.parse(json)
	pkg["// nw-screemsaver's monkey-patch.coffee"] = "adding main: index.js"
	pkg.main = "index.js"
	json = JSON.stringify(pkg, null, 2)

	writeFileAndLog packageJSON, json
