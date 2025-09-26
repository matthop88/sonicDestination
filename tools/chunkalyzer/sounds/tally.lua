local SOUND_MANAGER = require("tools/lib/soundManager")

return { 
	soundPath = "tools/chunkalyzer/sounds/files/",
	soundName = "tally",

	play = function(self)
		SOUND_MANAGER:play(self.soundPath, self.soundName)
	end,
}
