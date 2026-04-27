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
        ballThud        = "thud",
	},

	setOverride = function(self, key, value) self.overrides[key] = value end,

	-- Map / construction-set rows are keyed by action serial (e.g. ballThud); each row may set
	-- .sound to a soundData key. If .sound is missing, use actionSoundMap[actionKey] as the
	-- default sample so effect-only edits still merge (otherwise thud never picks up Reverb/Echo).
	mergePropsIntoElement = function(self, soundKey, element, propsTable)
		if not propsTable then return element end
		for actionKey, p in pairs(propsTable) do
			if type(p) == "table" then
				local rowSound = p.sound
				local matches = false
				if rowSound == "None" then
					matches = false
				elseif rowSound ~= nil then
					matches = (rowSound == soundKey)
				else
					matches = (self.actionSoundMap[actionKey] == soundKey)
				end
				if matches then
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
		if not base then 
            print("Data not found for " .. soundKey)
            return end
		local props = propsTable or (_G.getProperties and getProperties().sounds) or nil
		local merged = self:mergePropsIntoElement(soundKey, shallowCopy(base), props)
		self:createSoundFromElement(soundKey, merged)
	end,

	play = function(self, soundName)
		local sound = self:getByName(soundName)
        if sound then
    		sound:setVolumeScalar(self.volumeScalar)
    		if sound.delay then self:addToQueue(sound)
    		else                sound:play(self)    end
        end
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
		for actionKey, sound in pairs(soundProps) do
			if type(sound) == "table" then
				local k = sound.sound
				if (not k or k == "None") and self.actionSoundMap[actionKey] then
					k = self.actionSoundMap[actionKey]
				end
				if k and k ~= "None" and not rebuilt[k] then
					rebuilt[k] = true
					self:rebuildSound(k, soundProps)
				end
			end
		end
		for action, sound in pairs(soundProps) do
			if type(sound) == "table" and type(action) == "string" then
				self:setActionOverride(action, sound.sound)
				local defaultName = self.actionSoundMap[action]
				local soundObj = defaultName and self:getByName(defaultName)
				if soundObj then
					if sound.volume then soundObj:setVolume(sound.volume) end
					if sound.pitch then soundObj:setPitch(sound.pitch) end
				end
			end
		end
	end,

}):init()
