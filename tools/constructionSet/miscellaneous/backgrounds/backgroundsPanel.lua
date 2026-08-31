return {
	create = function(self, params)
		local backgroundProperties = getProperties():getBackground()
				
		return require("tools/constructionSet/miscellaneous/genericPanel"):create {
			title     = "Background Settings",
			x         = params.x,
			y         = params.y,
			w         = params.w,
			h         = params.h,

			components = {
				topX = 20,
				topY = 80,
				w    = 300,
				h    = 50,
				gapX = 30,
				gapY = 10,

				{
					name          = "Background",
					type          = "dropDown",
					label         = "Background",
					list          = require("tools/constructionSet/miscellaneous/backgrounds/backgroundsList"),
					selectedValue = backgroundProperties.background,
					onChanged     = function(item, index)
						backgroundProperties.background = item.value
					end,
				},
			},
		}			
	end,
}
