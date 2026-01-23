local SINE_WAVE  = require("tools/badnikUniversity/scripts/commands/sineWave")
local WAIT       = require("tools/badnikUniversity/scripts/commands/wait")
local FLIPX      = require("tools/badnikUniversity/scripts/commands/flipX")

return {
	name    = "sineWaveBackAndForth",
	title   = "Sine Wave Back and Forth",
	program = {
		SINE_WAVE { numSeconds = 3, speed = 5, amplitude = 100, wavelength = 50, },
		FLIPX(),
	},
}
