
fs = require "fs"
{spawn} = require "child_process"
nexeres = require "nexeres"
path = require "path-extra"

datadir = path.datadir "nw-screensaver"
zip_file = path.join datadir, "app.zip"
nwjs_dl_folder = path.join datadir, "nw.js"
nwjs_exe = path.join nwjs_dl_folder, "nw.exe"
nwjs_url = "http://dl.nwjs.io/v0.12.3/nwjs-v0.12.3-win-x64.zip"
try fs.mkdirSync datadir
try fs.mkdirSync nwjs_dl_folder

zip = nexeres.get "app.zip"

run = ->
	console.log nwjs_exe, zip_file, process.argv
	console.log "spawn", nwjs_exe, [zip_file, process.argv.slice(2)...], detached: yes, stdio: ["ignore", "ignore", "ignore"]
	proc = spawn nwjs_exe, [zip_file, process.argv.slice(2)...], detached: yes, stdio: ["ignore", "ignore", "ignore"]
	proc.unref()

fs.writeFile zip_file, zip, (err)->
	throw err if err
	if fs.existsSync nwjs_exe
		run()
	else
		downloader = require "nw-builder/lib/downloader.js"
		downloader.downloadAndUnpack nwjs_dl_folder, nwjs_url
		.then run
		.catch (err)->
			console.error "Failed to download and unpack #{nwjs_url} to #{nwjs_dl_folder}: #{err}"
