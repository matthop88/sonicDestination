return {
	sonicBraking   = { label = "Sonic Braking",    filename = "brake.ogg",             volume = 0.2,  startPoint =  1982, endPoint =  44098, },
	sonicJumping   = { label = "Sonic Jumping",    filename = "jump.ogg",              volume = 0.2,                      endPoint =  38712, },
	sonicCDJumping = { label = "Sonic CD Jumping", filename = "sonicCDJump.mp3",       volume = 0.9,  startPoint = 19520, endPoint =  38519, },
	ringCollectL   = { label = "Ring Collect L",   filename = "ring-collect-L.mp3",    volume = 0.4,  startPoint =  1636, endPoint =  55260  },
	ringCollectR   = { label = "Ring Collect R",   filename = "ring-collect-R.mp3",    volume = 0.4,  startPoint =  2984, endPoint =  58018, },
	giantRing      = { label = "Giant Ring",       filename = "giantRing.mp3",         volume = 0.5,  startPoint =  4352, endPoint =  95882, },
	vanish         = { label = "Vanish",           filename = "vanish.mp3",            volume = 0.5,  startPoint =  3968, endPoint = 162026, },
	badnikDeath    = { label = "Badnik Death",     filename = "badnik-death.ogg",      volume = 0.5,  startPoint =  5328, endPoint =  45192, },
	sonicHit       = { label = "Sonic Hit",        filename = "sonicHit.ogg",          volume = 0.8,  startPoint =  2134, endPoint =  81806, },
	iceExplode     = { label = "Ice Explode",      filename = "extra/IceExplode1.wav", volume = 0.8,  startPoint =  4892, endPoint =  45896, },
	klank          = { label = "Klank",            filename = "extra/AnvilDing.wav",   volume = 0.8,  startPoint = 11076, endPoint =  41006, },
	ouch           = { label = "Ouch",             filename = "extra/Ooouuucchh.wav",  volume = 0.8,  startPoint =  8182, endPoint =  38054, },
	smoosh         = { label = "Smoosh",           filename = "extra/smoosh.wav",      volume = 1.0, },
	sneakers       = { label = "Sneakers",         filename = "extra/sneakers.wav",    volume = 0.45, pitch = 1.3, },
	thud           = { label = "Thud",             filename = "extra/sor2Thud.wav",    volume = 1.0, },
	yaaaaah        = { label = "Yaaaaah!",         filename = "extra/Yaaaaaaa!.wav",   volume = 1.0, },
	pushRock       = { label = "Push Rock",        filename = "pushRock.wav",          volume = 1.0, },
	klankOuch      = { label = "Klank Ouch!",      complex  = true,
        { filename = "extra/AnvilDing.wav",   volume = 0.8, startPoint = 11076, endPoint =  41006,             },
        { filename = "extra/Ooouuucchh.wav",  volume = 0.8, startPoint =  8182, endPoint =  38054, delay = 0.25 },
    },
    bowlingStrike  = { 
    	label = "Bowling Strike",   filename = "extra/emycutiepantsBowlingStrike.mp3",
    	-- Credit to Emycutiepants https://pixabay.com/users/_emycutiepants_-50116316 
    },
    
}
