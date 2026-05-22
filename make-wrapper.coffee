
path = require "path"
zip = require "zip-folder"
concat = require "concat-files"

winresourcer =
	try
		require "nw-builder/node_modules/winresourcer"
	catch
		require "winresourcer"

change_exe_subsystem = require "./subsystem"

app_folder = "app"
app_exe = "nw-screensaver.scr"
zip_file = "app.zip"
win_ico = "#{app_folder}/img/icon.ico"
nw_exe = "#{app_folder}/nw-screensaver.exe" # this in the app folder... probably doing this wrong.


replace_icon = (file, cb)->
	console.log "Delete the Node.js icon from #{app_exe}"
	winresourcer
		operation: "Delete"
		exeFile: path.resolve app_exe
		resourceFile: path.resolve win_ico
		resourceType: "Icon"
		resourceName: 1
		lang: 1033
		(err)->
			return cb err if err
			console.log "Add the new icon to #{app_exe}"
			winresourcer
				operation: "Add"
				exeFile: path.resolve app_exe
				resourceFile: path.resolve win_ico
				resourceType: "Icon"
				resourceName: 1
				lang: 1033
				(err)->
					return cb err if err

console.log "Zipping", app_folder, "to", zip_file
zip app_folder, zip_file, (err)->
	throw err if err
	console.log "Zip complete"
	console.log "Combining nw binary #{nw_exe} and zip file into #{app_exe}"
	concat [nw_exe, zip_file], app_exe, (err)->
		throw err if err
		console.log "Concat complete"
		replace_icon app_exe, (err)->
			throw err if err
			console.log "Making the exe into a GUI app so it doesn't show the console"
			change_exe_subsystem app_exe, "GUI"
			console.log "Done!"
