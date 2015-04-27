
@get = (key)->
	# console.log "get", key
	item = localStorage.getItem key
	# console.log "item:", item
	if item is "undefined" then return
	value = JSON.parse item if item
	# console.log "return", value
	console.log "get #{key} =>", value
	value

@set = (key, value)->
	console.log "set", key, "to", value
	localStorage.setItem key, JSON.stringify value

@unset = (key)->
	localStorage.removeItem key


@ssget = (id, key)->
	console.log "ssget", id, key
	screensavers = get "screensavers"
	for scr in screensavers when scr.id is id
		console.log "scr:", scr
		return scr[key]

@ssset = (id, key, value)->
	console.log "ssset", id, key, value
	screensavers = get "screensavers"
	# screensaver = null
	for scr in screensavers when scr.id is id
		console.log "scr:", scr
		scr[key] = value
	# 	screensaver = scr
	# screensaver ?= {id}
	# screensaver[key] = value
	set "screensavers", screensavers

@ssunset = (id, key)->
	console.log "ssunset", id, key
	screensavers = get "screensavers"
	for scr in screensavers when scr.id is id
		console.log "scr:", scr
		delete scr[key]
	set "screensavers", screensavers

@removess = (id)->
	if (get "current") is id
		set "current", nextAfter id
	if (get "screensavers").length is 1
		setDefaultSS()
	else
		set "screensavers", (scr for scr in get "screensavers" when scr.id isnt id)

@addss = (scr)->
	set "screensavers", (get "screensavers").concat [scr]

@nextAfter = (id)->
	console.log "get next after #{id}"
	screensavers = get "screensavers"
	for scr, i in screensavers when scr.id is id
		console.log "scr:", scr
		next = screensavers[(i+1) % screensavers.length]
		console.log "next:", next
		return next?.id

@first = ->
	

@setDefaultSS = ->
	new_default_id = guid()
	set "screensavers", [
		title: "Pipes"
		url: "http://isaiahodhner.ml/pipes/"
		id: new_default_id
	]
	set "current", new_default_id

# misnomer: not a globally unique identifier
# actually: generate unique...ish identifier
@guid = ->
	Math.pow(2.1e16, Math.random()).toString(16)


screensavers = (get "screensavers") ? []
unless screensavers.length
	setDefaultSS()
