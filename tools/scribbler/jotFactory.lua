return {
	tools = {
		line     = require("tools/scribbler/jotTools/line"),
		rect     = require("tools/scribbler/jotTools/rect"),
		scribble = require("tools/scribbler/jotTools/scribble"),
	},

	createJot = function(self, name, data)
		return self.tools[name]:createJotFromData(data)
	end,
}
