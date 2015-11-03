
path = require "path"
nexe = require "nexe"
zip = require "zip-folder"

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
		resourceFiles: [zip_file]
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
							# console.log "Make the exe into a GUI app so it doesn't show the console"
							# change_exe_subsystem app_exe, "GUI"
							console.log "Done!"
