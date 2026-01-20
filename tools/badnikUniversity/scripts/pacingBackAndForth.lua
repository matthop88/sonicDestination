local MOVE        = require("tools/badnikUniversity/scripts/commands/move")
local WAIT        = require("tools/badnikUniversity/scripts/commands/wait")
local FLIPX       = require("tools/badnikUniversity/scripts/commands/flipX")

return {
	name         = "pacingBackAndForth",
	title        = "Pacing Back and Forth",
	instructions = {
		MOVE { xSpeed = 100, numSeconds = 3 },
		WAIT(1),
		FLIPX(),
		WAIT(1),
	},
}
