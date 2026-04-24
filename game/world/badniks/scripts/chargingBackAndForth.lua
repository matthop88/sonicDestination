local MOVE_TOWARDS_EDGE  = requireRelative("world/badniks/scripts/commands/moveTowardsEdge")
local WAIT               = requireRelative("world/badniks/scripts/commands/wait")
local FLIPX              = requireRelative("world/badniks/scripts/commands/flipX")

return {
	name    = "chargingBackAndForth",
	title   = "Charging Back and Forth",
	program = {
		MOVE_TOWARDS_EDGE { xSpeed     = 200, animation = "charging", },
		WAIT              { numSeconds =   1, animation = "moving",   },
		FLIPX(),
		WAIT              { numSeconds =   1, },
	},
}
