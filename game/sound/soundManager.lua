local function shallowCopy(t)
	if not t then return {} end
	local u = {}
	for k, v in pairs(t) do
		u[k] = v
	end
	return u
end

return ({
	sounds       = {},
	overrides    = {},
	queuedSounds = requireRelative("util/dataStructures/linkedList"):create(),
	volumeScalar = 1,

	actionSoundMap = {
		braking         = "sonicBraking",
		jumping         = "sonicJumping",
		collectOddRing  = "ringCollectL",
		collectEvenRing = "ringCollectR",
		giantRing       = "giantRing",
		vanish          = "vanish",
		sonicHit        = "sonicHit",
		badnikHit       = "badnikDeath",
	},

	setOverride = function(self, key, value) self.overrides[key] = value end,

	-- Map / construction-set rows use the asset key in .sound; merge fx onto that soundData entry.
	-- If p.audioEffect is nil, keep the base soundData effect (row has not set effect in the panel).
	mergePropsIntoElement = function(self, soundKey, element, propsTable)
		if not propsTable then return element end
		for _, p in pairs(propsTable) do
			if p.sound == soundKey then
				if p.reverse ~= nil then
					element.reverse = p.reverse
				end
				if p.audioEffect ~= nil then
					if p.audioEffect ~= "None" then
						element.effect = {
							type      = p.audioEffect,
							delay     = p.delay ~= nil and p.delay or 0.5,
							strength  = p.strength ~= nil and p.strength or 0.5,
							echoCount = p.echoCount,
							detuning  = p.detuning,
						}
					else
						element.effect = { type = "None", }
					end
				end
			end
		end
		return element
	end,

	createSoundFromElement = function(self, name, element)
		if #element > 0 then
			self.sounds[name] = requireRelative("sound/complexSound"):create(element)
		else
			self.sounds[name] = requireRelative("sound/simpleSound"):create(element)
		end
	end,

	init = function(self)
		self:initSoundData()
		return self
	end,

	initSoundData = function(self)
		local data = requireRelative("sound/soundData")
		local props = (_G.getProperties and getProperties().sounds) or nil
		for name, element in pairs(data) do
			local merged = self:mergePropsIntoElement(name, shallowCopy(element), props)
			self:createSoundFromElement(name, merged)
		end
	end,

	rebuildSound = function(self, soundKey, propsTable)
		local data = requireRelative("sound/soundData")
		local base = data[soundKey]
		if not base then return end
		local props = propsTable or (_G.getProperties and getProperties().sounds) or nil
		local merged = self:mergePropsIntoElement(soundKey, shallowCopy(base), props)
		self:createSoundFromElement(soundKey, merged)
	end,

	play = function(self, soundName)
		local sound = self:getByName(soundName)
		sound:setVolumeScalar(self.volumeScalar)
		if sound.delay then self:addToQueue(sound)
		else                sound:play(self)    end
	end,

	getByName = function(self, soundName)
		if self.overrides[soundName] then soundName = self.overrides[soundName] end
		return self.sounds[soundName]
	end,

	addToQueue = function(self, sound)
		self.queuedSounds:add({ timer = sound.delay, sound = sound })
	end,

	update = function(self, dt)
		for _, sound in pairs(self.sounds) do
			if sound.update then sound:update(dt) end
		end
		self.queuedSounds:forEach(function(delayedSound)
			delayedSound.timer = delayedSound.timer - dt
			if delayedSound.timer <= 0 then
				delayedSound.sound:play()
				self.queuedSounds:remove()
				return true
			end
		end)
	end,

	onPropertyChange = function(self, propData)
		if propData.volume and propData.volume.sounds then
			self.volumeScalar = propData.volume.sounds
		end
	end,

	setActionOverride = function(self, key, value)
		self:setOverride(self.actionSoundMap[key], value)
	end,

	overrideFromSoundProps = function(self, soundProps)
		if soundProps == nil then return end
		local rebuilt = {}
		for _, sound in pairs(soundProps) do
			local k = sound.sound
			if k and k ~= "None" and not rebuilt[k] then
				rebuilt[k] = true
				self:rebuildSound(k, soundProps)
			end
		end
		for action, sound in pairs(soundProps) do
			self:setActionOverride(action, sound.sound)
			local soundObj = self:getByName(self.actionSoundMap[action])
			if soundObj then
				if sound.volume then soundObj:setVolume(sound.volume) end
				if sound.pitch then soundObj:setPitch(sound.pitch) end
			end
		end
	end,

}):init()
