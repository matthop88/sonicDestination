local SINE_WAVE  = requireRelative("world/badniks/scripts/commands/sineWave")
local WAIT       = requireRelative("world/badniks/scripts/commands/wait")
local FLIPX      = requireRelative("world/badniks/scripts/commands/flipX")

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
