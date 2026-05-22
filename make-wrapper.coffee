
fs = require "fs"
path = require "path"
nexe = require "nexe"
zip = require "zip-folder"
winresourcer = require "winresourcer"

change_exe_subsystem = require "./subsystem"

app_folder = "app"
app_exe = "nw-screensaver.scr"
zip_file = "app.zip"
win_ico = "#{app_folder}/img/icon.ico"
nwjs_version = "v0.54.1"
nwjs_flavor = "sdk"
nwjs_cache_folder = "temp/nwjs_cache"

console.log "Get NW.js #{nwjs_version} (#{nwjs_flavor}) from the cache or download it to #{nwjs_cache_folder}"
import("@nwutils/getter")
	.then (getter_module)->
		get = getter_module.default
		get_options =
			version: nwjs_version
			flavor: nwjs_flavor
			platform: "win"
			arch: "x64"
			downloadUrl: "https://dl.nwjs.io"
			manifestUrl: "https://nwjs.io/versions.json"
			cacheDir: nwjs_cache_folder
			cache: true
			ffmpeg: false
			nativeAddon: false
			shaSum: true
		get get_options
		.then ()->
			console.log "dir contents", fs.readdirSync(nwjs_cache_folder)
			nw_folder = path.join nwjs_cache_folder, "nwjs-#{nwjs_flavor}-#{nwjs_version}-#{get_options.platform}-#{get_options.arch}"
			nw_zip = path.join nwjs_cache_folder, "nwjs-#{nwjs_flavor}-#{nwjs_version}-#{get_options.platform}-#{get_options.arch}.zip"
			nw_exe = path.join nw_folder, "nw.exe"
			console.log "nw_exe", nw_exe
			console.log "nw_exe exists?", fs.existsSync(nw_exe)
			console.log "Zip", app_folder, "to", zip_file
			zip app_folder, zip_file, (err)->
				throw err if err
				console.log "Compile ./wrapper.js to #{app_exe} with nexe"
				nexe.compile
					input: "./wrapper.js"
					output: app_exe
					nodeVersion: "0.12.6"
					framework: "nodejs"
					nodeTempDir: "temp"
					python: process.env.PYTHON or "python"
					flags: true
					resourceFiles: [zip_file, nw_zip]
					(err)->
						throw err if err
						console.log "Delete the Node.js icon from #{app_exe}"
						winresourcer
							operation: "Delete"
							exeFile: path.resolve app_exe
							resourceFile: path.resolve win_ico
							resourceType: "Icon"
							resourceName: 1
							lang: 1033
							(err)->
								throw err if err
								console.log "Add the new icon to #{app_exe}"
								winresourcer
									operation: "Add"
									exeFile: path.resolve app_exe
									resourceFile: path.resolve win_ico
									resourceType: "Icon"
									resourceName: 1
									lang: 1033
									(err)->
										throw err if err
										console.log "Make the exe into a GUI app so it doesn't show the console"
										change_exe_subsystem app_exe, "GUI"
										console.log "Done!"
		.catch (err)->
			console.error "Failed to download and unpack nwjs: #{err.stack}"
			process.exit 1
