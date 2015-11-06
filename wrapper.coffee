
fs = require "fs"
{spawn} = require "child_process"
nexeres = try require "nexeres"
path = require "path-extra"

datadir = path.datadir "nw-screensaver"
zip_file = path.join datadir, "app.zip"
nwjs_dl_folder = path.join datadir, "nw.js"
nwjs_exe = path.join nwjs_dl_folder, "nw.exe"
nwjs_version = "v0.12.3"
nwjs_url = "http://dl.nwjs.io/#{nwjs_version}/nwjs-#{nwjs_version}-win-x64.zip"
try fs.mkdirSync datadir
try fs.mkdirSync nwjs_dl_folder

get_app_location = (callback)->
	if nexeres
		zip = nexeres.get "app.zip"
		fs.writeFile zip_file, zip, (err)->
			callback err, zip_file
	else
		callback null, path.join __dirname, "app"

run = ->
	get_app_location (err, app_location)->
		throw err if err
		proc = spawn nwjs_exe, [app_location, process.argv.slice(2)...], detached: yes, stdio: ["ignore", "ignore", "ignore"]
		proc.unref()

if fs.existsSync nwjs_exe
	run()
else
	downloader = require "nw-builder/lib/downloader.js"
	downloader.downloadAndUnpack nwjs_dl_folder, nwjs_url
	.then run
	.catch (err)->
		console.error "Failed to download and unpack #{nwjs_url} to #{nwjs_dl_folder}: #{err}"
