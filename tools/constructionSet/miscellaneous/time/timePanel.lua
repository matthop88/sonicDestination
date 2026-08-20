return {
	create = function(self, params)
		local timeProperties = getProperties():getTime()
				
		return require("tools/constructionSet/miscellaneous/genericPanel"):create {
			title     = "Time Settings",
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
					name          = "timesAtStart",
					type          = "dropDown",
					label         = "Time at Start",
					list          = require("tools/constructionSet/miscellaneous/time/timesAtStart"),
					selectedValue = timeProperties.timeAtStart,
					onChanged     = function(item, index)
						timeProperties.timeAtStart = item.value
					end,
				},
				{
					name          = "timeText",
					type          = "editableTextField",
					label         = "Text",
					text          = getProperties().time.timeLabel or "time",
					onChanged     = function(text) getProperties():getTime().timeLabel = text end,
					validKeys     = { "b", "c", "e", "g", "i", "m", "n", "o", "r", "s", "t", "u", },
				},
				{
					name          = "timeMonitorDurations",
					type          = "dropDown",
					label         = "Monitor Duration",
					list          = require("tools/constructionSet/miscellaneous/time/timeMonitorDurations"),
					selectedValue = timeProperties.timeMonitorDurations,
					onChanged     = function(item, index)
						timeProperties.timeMonitorDurations = item.value
					end,
				},
			},
		}			
	end,
}
