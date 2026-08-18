return {
	create = function(self, params)
		return require("tools/constructionSet/miscellaneous/panelButton"):create {
			label       = "Time",
			createPanel = function(self)
				return require("tools/constructionSet/miscellaneous/genericPanel"):create {
					title = "Time Settings",
					x     = 300,
					y     = 150,
					w     = 830,
					h     = 400,
				}
			end,
		}
	end,
}
