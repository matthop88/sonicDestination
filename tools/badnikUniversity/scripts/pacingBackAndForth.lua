local SET_X_SPEED = function(xSpeed)
	-- do nothing
end

local MOVE        = function(numSeconds)
	-- do nothing
end

local WAIT        = function(numSeconds)
	-- do nothing
end

local FLIPX       = function()
	-- do nothing
end

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
