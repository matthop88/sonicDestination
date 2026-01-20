local SET_X_SPEED = require("tools/badnikUniversity/scripts/commands/setXSpeed")
local MOVE        = require("tools/badnikUniversity/scripts/commands/move")
local WAIT        = require("tools/badnikUniversity/scripts/commands/wait")
local FLIPX       = require("tools/badnikUniversity/scripts/commands/flipX")

return {
	name         = "pacingBackAndForth",
	title        = "Pacing Back and Forth",
	instructions = {
		SET_X_SPEED(100),
		MOVE(3),
		SET_X_SPEED(0),
		WAIT(1),
		FLIPX(),
		WAIT(1),
	},
}
