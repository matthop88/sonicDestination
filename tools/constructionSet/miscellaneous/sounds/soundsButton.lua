return {
	create = function(self, params)
		return require("tools/constructionSet/miscellaneous/panelButton"):create {
			label       = "Sounds",
			createPanel = function(self)
				return require("tools/constructionSet/miscellaneous/sounds/soundsPanel"):create {
					x = 300,
					y = 250,
					width = 830,
					height = 470,
				}
			end,
		}
	end,
}
