
fs = require 'fs'
glob = require 'glob'
NwBuilder = require 'node-webkit-builder'

nw = new NwBuilder
	files: './app/**'
	platforms: ['osx32', 'osx64', 'win32', 'win64', 'linux32', 'linux64']
	version: process.env.NW_VERSION ? "0.12.1"


nw.on 'log', console.log

task 'build', ->
	nw.build()
		.then ->
			console.log '(done build)'
			glob "build/*/win*/*.exe", (err, files)->
				return console.error err if err
				for file in files
					fs.rename file, file.replace(".exe", ".scr"), (err)->
						if err
							console.error err
						else
							console.log "renamed #{file} to *.scr"
		.catch (error)->
			console.error(error)

task 'run', ->
	nw.run()
		.then ->
			console.log '(done running)'
		.catch (error)->
			console.error error

