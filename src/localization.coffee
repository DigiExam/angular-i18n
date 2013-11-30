angular.module("localization", [])
	.factory("localize", ["$http", "$rootScope", "$window", "$filter", ($http, $rootScope, $window, $filter)->
		userLanguage = navigator.language
		if userLanguage is undefined
			userLanguage = if typeof navigator.userLanguage is "string" then navigator.userLanguage.split("-")[0] else ""

		localize = 
			language: ""
			userLanguage: userLanguage
			dictionary: {}
			resourceFileLoaded: false

			setLanguage: (lang)->
				localize.resourceFileLoaded = false
				
				url = "js/i18n/locale-" + lang + ".js"
				promise = localize._getDictionary(url)
				promise.success (data)->
					localize.dictionary = data
					localize.resourceFileLoaded = true
					localize.language = lang

			_getDictionary: (url)->
				$http({ method: "GET", url: url, cache: false })

			get: (key)->
				return localize.dictionary[key] || key

	])
	.filter("i18n", ["localize", (localize)->
		return (input)->
			return localize.get input
	])