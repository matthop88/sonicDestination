local MOVE  = require("tools/badnikUniversity/scripts/commands/move")
local WAIT  = require("tools/badnikUniversity/scripts/commands/wait")
local FLIPX = require("tools/badnikUniversity/scripts/commands/flipX")

return {
	name    = "pacingBackAndForth",
	title   = "Pacing Back and Forth",
	program = require("tools/lib/dataStructures/navigableList"):create {
		MOVE { numSeconds = 3, xSpeed = 100, },
		WAIT { numSeconds = 1,               },
		FLIPX(),
		WAIT { numSeconds = 1,               },
	},
}
