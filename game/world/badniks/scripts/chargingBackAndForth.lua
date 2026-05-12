local MOVE_TOWARDS_EDGE   = requireRelative("world/badniks/scripts/commands/moveTowardsEdge")
local WAIT                = requireRelative("world/badniks/scripts/commands/wait")
local FLIPX               = requireRelative("world/badniks/scripts/commands/flipX")
local BRANCH_IF_PLAYER_AT = requireRelative("world/badniks/scripts/commands/branchIfPlayerAt")
local GO_TO_PROGRAM       = requireRelative("world/badniks/scripts/commands/goToProgram")

return {
	name     = "chargingBackAndForth",
	title    = "Charging Back and Forth",
	programs = {
		default = {
			BRANCH_IF_PLAYER_AT { deltaX   = 200, program = "charging", },
			MOVE_TOWARDS_EDGE { xSpeed     =  50, animation = "moving", },
			WAIT              { numSeconds =   1, },
			FLIPX(),
			WAIT              { numSeconds =   1, },
		},
		charging = {
			MOVE_TOWARDS_EDGE { xSpeed     = 200, animation = "charging", numSeconds = 1, },
			GO_TO_PROGRAM     { program = "default", },
		}
	},
}
