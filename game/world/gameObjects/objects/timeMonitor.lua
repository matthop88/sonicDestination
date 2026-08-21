local SOUND_MANAGER  = requireRelative("sound/soundManager")

local onDestroy = function(self)
	SOUND_MANAGER:playAction("timeMonitorPop")
	self.world:setTimeModifier(0.5)
end
						
return {
	create = function(self)
		local timeMonitor = requireRelative("world/gameObjects/objects/super/monitor"):create()
		timeMonitor.onMonitorDestroyed = onDestroy
		return timeMonitor
	end,
}
