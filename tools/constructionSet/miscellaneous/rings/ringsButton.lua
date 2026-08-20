return {
	create = function(self, params)
		return require("tools/constructionSet/miscellaneous/panelButton"):create {
			label       = "Rings",
			createPanel = function(self)
				return require("tools/constructionSet/miscellaneous/rings/ringsPanel"):create {
					x     = 300,
					y     = 150,
					w     = 830,
					h     = 400,
				}
			end,
		}
	end,
}
