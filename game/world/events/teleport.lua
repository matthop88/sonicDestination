local WORLD

local READY =      { duration =  0,                                                 }
local FADING_OUT = { duration = 60, activate = function(self) WORLD:fadeOut()  end, } 
local RESETTING  = { duration =  0, activate = function(self) WORLD:reset()    end, }
local FADING_IN  = { duration = 60, activate = function(self) WORLD:fadeIn()   end, }
local DONE       = {}

local STAGES = { 
	READY,
	FADING_OUT,
	RESETTING,
	FADING_IN,
	DONE,

	index           = 1,

	get             = function(self) return self[self.index]                           end,
	next            = function(self) self.index = math.min(self.index + 1, #self)      end,
	completed       = function(self) return self.index == #self                        end,
	
	readyForNext    = function(self, timer)
		local stage = self:get()
		return stage.duration and timer > stage.duration
	end,

	activateCurrent = function(self) 
		if self:get().activate then self:get():activate() end
	end,
}

return {
	create = function(self, world)
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
				STAGES:activateCurrent()
			end,

			isComplete = function(self)
				return STAGES:isComplete()
			end,
		}
	end,
}
