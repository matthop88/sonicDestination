local SOUND_MANAGER  = requireRelative("sound/soundManager")

local onDestroy = function(self)
	SOUND_MANAGER:playAction("ringMonitorPop")
    self.player:incrementRingCount(self.world:getRingMonitorAmount())
end

return {
	create = function(self)
		local ringMonitor = requireRelative("world/gameObjects/objects/super/monitor"):create()
		ringMonitor.onMonitorDestroyed = onDestroy
		return ringMonitor
	end,
}
