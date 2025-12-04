local WORLD
local STAGE_BUILDER = requireRelative("world/events/stageBuilder")
local SOUND_MANAGER = requireRelative("sound/soundManager")

local READY       = { duration = 5, }

local PLAYER_GONE = {
	duration = 50,

	activate = function(self, params)
		params.player:deactivate()
	end,                                               
}

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
		params.player:deactivate()
	end,
}

local FADING_IN    = { duration = 60, activate = function(self) WORLD:fadeIn() end }

local RING_ARRIVAL = { 
	duration = 60,
	activate = function(self, params)
		params.giantRing:arrive(params.x, params.y, params.player)
		params.player:activate()
		params.player:freeze()
		WORLD:addPreexistingObject(params.giantRing)
	end,
}

local UNFREEZING   = { duration = 60, activate = function(self, params) params.player:unfreeze()  end, }
local DEPARTING    = { duration = 60, activate = function(self, params) params.giantRing:depart() end, }
local DONE         = {}

return {
	create = function(self, world, params)
		WORLD = world
		return {
			STAGES = STAGE_BUILDER:build { READY, PLAYER_GONE, FADING_OUT, RESETTING, FADING_IN, RING_ARRIVAL, UNFREEZING, DEPARTING, DONE  },

			timer  = 0,
			
			update = function(self, dt)
				self.timer = self.timer + (60 * dt)
				if self.STAGES:readyForNext(self.timer) then self:nextStage() end
			end,

			nextStage = function(self)
				self.timer = 0
				self.STAGES:next()
				self.STAGES:activateCurrent(params)
			end,

			isComplete = function(self)
				return self.STAGES:completed()
			end,

			getName = function(self)
				return "teleport"
			end,
		}
	end,
}
