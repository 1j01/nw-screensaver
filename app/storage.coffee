
@get = (n, prop)->
	localStorage.getItem "ss#{n}.#{prop}"

@set = (n, prop, value)->
	localStorage.setItem "ss#{n}.#{prop}", value

@unset = (n, prop)->
	localStorage.removeItem "ss#{n}.#{prop}"

unless get 0, "url"
	set 0, "url", "http://isaiahodhner.ml/pipes/"
	set 0, "title", "Pipes"
