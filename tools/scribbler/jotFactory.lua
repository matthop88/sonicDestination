return {
	tools = {
		line     = require("tools/scribbler/jotTools/line"),
		rect     = require("tools/scribbler/jotTools/rect"),
		scribble = require("tools/scribbler/jotTools/scribble"),
	},

	createJot = function(self, jotData)
		local name, data, color = jotData.name, jotData.data, jotData.color
		data.color = color
		
		return self.tools[name]:createJotFromData(data)
	end,
}
