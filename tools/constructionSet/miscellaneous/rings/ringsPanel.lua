return {
	create = function(self, params)
		local ringProperties = getProperties():getRings()
				
		return require("tools/constructionSet/miscellaneous/genericPanel"):create {
			title     = "Ring Settings",
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
					name          = "ringsAtStart",
					type          = "dropDown",
					label         = "Rings at Start",
					list          = require("tools/constructionSet/miscellaneous/rings/ringsAtStart"),
					selectedValue = ringProperties.ringsAtStart or 0,
					onChanged     = function(item, index)
						ringProperties.ringsAtStart = item.value
					end,
				},
				{
					name          = "ringsText",
					type          = "editableTextField",
					label         = "Text",
					text          = ringProperties.ringsLabel or "rINgs",
					onChanged     = function(text) ringProperties.ringsLabel = text end,
					validKeys     = { "b", "c", "e", "g", "i", "I", "m", "n", "N", "o", "r", "s", "t", "u", },
				},
				{
					name          = "ringCountLost",
					type          = "dropDown",
					label         = "Num Rings Lost",
					list          = require("tools/constructionSet/miscellaneous/rings/ringCountLost"),
					selectedValue = ringProperties.ringCountLost or -1,
					onChanged     = function(item, index)
						ringProperties.ringCountLost = item.value
					end,
				},
				{
					name          = "ringMonitorAmount",
					type          = "dropDown",
					label         = "# Monitor Rings",
					list          = require("tools/constructionSet/miscellaneous/rings/ringMonitorAmount"),
					selectedValue = ringProperties.ringMonitorAmount or 10,
					onChanged     = function(item, index)
						ringProperties.ringMonitorAmount = item.value
					end,
				},
			},
		}			
	end,
}
