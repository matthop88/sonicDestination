local SINE_WAVE  = require("tools/badnikUniversity/scripts/commands/sineWave")
local WAIT       = require("tools/badnikUniversity/scripts/commands/wait")
local FLIPX      = require("tools/badnikUniversity/scripts/commands/flipX")

return {
	name    = "sineWaveBackAndForth",
	title   = "Sine Wave Back and Forth",
	program = {
		SINE_WAVE { numSeconds = 7, speed = 2, amplitude = 25, wavelength = 35, },
		WAIT { numSeconds = 0.3 },
		FLIPX(),
		WAIT { numSeconds = 0.3 },
	},
}
