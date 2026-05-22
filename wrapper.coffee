

fs = require "fs"
{spawn} = require "child_process"
nexeres = try require "nexeres"
path = require "path"
ospath = require "ospath"

nwjs_version = "v0.26.3"
nwjs_flavor = "sdk"

datadir = path.join ospath.data(), "nw-screensaver"
zip_file = path.join datadir, "app.zip"
nwjs_dl_folder = path.join datadir, "nwjs-#{nwjs_flavor}-#{nwjs_version}"
nwjs_exe = path.join nwjs_dl_folder, "nw.exe"
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
	# console.log "run"
	get_app_location (err, app_location)->
		# console.log "app_location", app_location
		throw err if err
		# http://www.codersnotes.com/notes/something-rotten-in-the-core/
		proc = spawn nwjs_exe, [app_location, process.argv.slice(2)...], detached: yes, stdio: "ignore"
		proc.unref()
		# without unref():
		# proc.on "exit", (code)->
		# 	console.error "exit code", code

if fs.existsSync nwjs_exe
	run()
else
	import("@nwutils/getter")
		.then (get)->
			get {cache: nwjs_dl_folder, version: nwjs_version, flavor: nwjs_flavor}
			.then run
			.catch (err)->
				console.error "Failed to download and unpack #{nwjs_url} to #{nwjs_dl_folder}: #{err}"
