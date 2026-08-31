return {
	create = function(self, params)
		return require("tools/constructionSet/miscellaneous/panelButton"):create {
			label       = "Backgrounds",
			fontSize    = 36,
			createPanel = function(self)
				return require("tools/constructionSet/miscellaneous/backgrounds/backgroundsPanel"):create {
					x     = 300,
					y     = 150,
					w     = 830,
					h     = 400,
				}
			end,
		}
	end,
}
