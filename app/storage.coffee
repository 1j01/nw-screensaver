
@get = (key)->
	item = localStorage.getItem key
	if item is "undefined" then return
	value = JSON.parse item if item
	console.log "get #{key} =>", value
	value

@set = (key, value)->
	console.log "set", key, "to", value
	localStorage.setItem key, JSON.stringify value

@unset = (key)->
	localStorage.removeItem key


@ss_get = (id, key)->
	console.log "ss_get", id, key
	screensavers = get "screensavers"
	for scr in screensavers when scr.id is id
		console.log "scr:", scr
		return scr[key]

@ss_set = (id, key, value)->
	console.log "ss_set", id, key, value
	screensavers = get "screensavers"
	for scr in screensavers when scr.id is id
		console.log "scr:", scr
		scr[key] = value
	set "screensavers", screensavers

@ss_unset = (id, key)->
	console.log "ss_unset", id, key
	screensavers = get "screensavers"
	for scr in screensavers when scr.id is id
		console.log "scr:", scr
		delete scr[key]
	set "screensavers", screensavers


@remove_ss = (id)->
	if (get "current") is id
		set "current", next_ss_after id
	if (get "screensavers").length is 1
		set_default_ss()
	else
		set "screensavers", (scr for scr in get "screensavers" when scr.id isnt id)

@add_ss = (scr)->
	set "screensavers", (get "screensavers").concat [scr]

@next_ss_after = (id)->
	console.log "get next after #{id}"
	screensavers = get "screensavers"
	for scr, i in screensavers when scr.id is id
		console.log "scr:", scr
		next = screensavers[(i+1) % screensavers.length]
		console.log "next:", next
		return next?.id

@set_default_ss = ->
	new_default_id = guid()
	set "screensavers", [
		title: "Pipes"
		url: "http://isaiahodhner.ml/pipes/"
		id: new_default_id
	]
	set "current", new_default_id

@first_ss = ->
	(get "screensavers")?[0]?.id

# misnomer: not a globally unique identifier
# actually: generate unique...ish identifier
@guid = ->
	Math.pow(2.1e16, Math.random()).toString(16)


screensavers = (get "screensavers") ? []
unless screensavers.length
	set_default_ss()
