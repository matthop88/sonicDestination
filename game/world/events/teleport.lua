local WORLD
local STAGE_BUILDER = requireRelative("world/events/stageBuilder")
local SOUND_MANAGER = requireRelative("sound/soundManager")

local READY =      { duration =  60,                                                }

local FADING_OUT = { 
	duration = 60, 
	activate = function(self) 
		WORLD:fadeOut()
		SOUND_MANAGER:play("vanish")  
	end, 
} 

local RESETTING  = { 
	duration =  0, 
	activate = function(self, params) 
		WORLD:reset(params.map, params.x, params.y)
	end,
}

local FADING_IN  = { duration = 60, activate = function(self) WORLD:fadeIn()            end, }
local DONE       = {}

local STAGES = STAGE_BUILDER:build { READY, FADING_OUT, RESETTING, FADING_IN, DONE  }

return {
	create = function(self, world, params)
		WORLD = world
		return {
			timer      = 0,
			
			update = function(self, dt)
				self.timer = self.timer + (60 * dt)
				if STAGES:readyForNext(self.timer) then self:nextStage() end
			end,

			nextStage = function(self)
				self.timer = 0
				STAGES:next()
				STAGES:activateCurrent(params)
			end,

			isComplete = function(self)
				return STAGES:isComplete()
			end,

			getName = function(self)
				return "teleport"
			end,
		}
	end,
}
