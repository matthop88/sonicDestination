local SOUND_MANAGER  = requireRelative("sound/soundManager")

local onDestroy = function(self)
	SOUND_MANAGER:play("doubleRing")
    self.player:incrementRingCount(10)
end

return {
	create = function(self)
		local ringMonitor = requireRelative("world/gameObjects/objects/super/monitor"):create()
		ringMonitor.onMonitorDestroyed = onDestroy
		return ringMonitor
	end,
}
