
fs = require "fs"
struct = require "bufferpack"

module.exports = (exe_path, subsystem="gui")->
	exe = fs.openSync exe_path, "r+"
	
	read = (position, length)->
		buffer = new Buffer length
		fs.readSync exe, buffer, 0, length, position
		buffer
	
	write = (position, buffer)->
		fs.writeSync exe, buffer, 0, buffer.length, position
	
	[PeHeaderOffset] = struct.unpack "<H", read 0x3c, 2
	[PeSignature] = struct.unpack "<I", read PeHeaderOffset, 4
	
	if PeSignature isnt 0x4550
		throw new Error "File is missing PE header signature"
	
	subsystem_value = switch subsystem.toLowerCase()
		when "console" then 3
		when "gui", "windows" then 2
	
	# console.log "Old subsystem value:", (struct.unpack "<H", read PeHeaderOffset + 0x5C, 2)[0]
	write PeHeaderOffset + 0x5C, struct.pack "<H", [subsystem_value]
	# console.log "New subsystem value:", (struct.unpack "<H", read PeHeaderOffset + 0x5C, 2)[0]
	
	fs.closeSync exe
