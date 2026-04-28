-- Build a new SoundData for the frame range [startPoint, endPoint] (interleaved indices, inclusive
-- of full frames), optionally reversing frame order. When endPoint is nil, uses end of source.
-- getSampleCount() on SoundData is frame count (see tools/soundGraph/soundObject.lua).
local function sliceReverseSoundData(full, startPoint, endPoint, reverse)
	local ch = full:getChannelCount()
	local frameCount = full:getSampleCount()
	if ch <= 0 or frameCount <= 0 then return full end

	local totalInterleaved = frameCount * ch

	local i0 = math.floor(startPoint or 0)
	i0 = math.max(0, math.min(i0, totalInterleaved - ch))
	i0 = i0 - (i0 % ch)

	local i1
	if endPoint ~= nil then
		i1 = math.floor(endPoint)
		i1 = math.max(0, math.min(i1, totalInterleaved - 1))
		i1 = i1 - (i1 % ch) + (ch - 1)
	else
		i1 = totalInterleaved - 1
	end

	if i1 < i0 then i0, i1 = i1, i0 end

	local firstFrame = math.floor(i0 / ch)
	local lastFrame = math.floor(i1 / ch)
	lastFrame = math.min(lastFrame, frameCount - 1)
	if lastFrame < firstFrame then firstFrame, lastFrame = lastFrame, firstFrame end

	local nframes = lastFrame - firstFrame + 1
	if nframes <= 0 then return full end

	local sr = full:getSampleRate()
	local out = love.sound.newSoundData(nframes, sr, 16, ch)

	for f = 0, nframes - 1 do
		local srcFrame = firstFrame + (reverse and (nframes - 1 - f) or f)
		for c = 1, ch do
			out:setSample(f, c, full:getSample(srcFrame, c))
		end
	end
	return out
end

local Sound = {
	create = function(self, params)
		local volume        = params.volume or 1
		local pitch         = params.pitch or 1
		local startPoint    = params.startPoint or 0
		local volumeScalar  = params.volumeScalar or 1
		local source        = params.source
		local delaySamples  = params.delay or 0
		local syncSource    = params.syncSource

		-- File-backed Sources often lack getSampleRate (depends on LÖVE version). Prefer
		-- explicit values from SoundData (see Track); fall back where the API exists.
		local sampleRate    = params.sampleRate
		local channelCount  = params.channelCount
		if not sampleRate or not channelCount then
			local okSr, sr = pcall(function() return source:getSampleRate() end)
			local okCh, ch = pcall(function() return source:getChannelCount() end)
			if okSr and okCh and sr and ch then
				sampleRate   = sr
				channelCount = ch
			else
				sampleRate   = sampleRate or 44100
				channelCount = channelCount or 1
			end
		end

		-- Match musicElement: indices are offsets in the interleaved PCM stream
		-- (each frame advances the index by channelCount).
		local function streamStride()
			return sampleRate * channelCount
		end

		local function getInterleavedSampleIndex(src)
			local t = src:tell("seconds")
			return math.floor(t * sampleRate * channelCount + 0.5)
		end

		local function seekToInterleavedSample(src, sampleIndex)
			sampleIndex = math.max(0, math.floor(sampleIndex + 0.5))
			local denom = streamStride()
			if denom <= 0 then return end
			src:seek(sampleIndex / denom, "seconds")
		end

		local delaySec = (delaySamples > 0 and streamStride() > 0) and (delaySamples / streamStride()) or 0
		local echoWaitArmed = false
		local echoWaitElapsed = 0
		local leaderWasPlaying = false

		return {
			-- Delayed echoes arm via syncSource:isPlaying() rising edge in update(). Very short dry
			-- clips can finish before the first SOUND_MANAGER:update, so the edge is never seen.
			-- Track:play calls this for the first hop; chainPrime links each hop to the next.
			primeFromSync = function(self)
				if delaySamples <= 0 or not syncSource or delaySec <= 0 then
					return
				end
				echoWaitArmed = true
				echoWaitElapsed = 0
				leaderWasPlaying = syncSource:isPlaying()
			end,

			chainPrime = nil,

			play = function(self)
				source:setVolume(volume * volumeScalar)
				source:setPitch(pitch)
				if startPoint and startPoint > 0 then
					seekToInterleavedSample(source, startPoint)
				end
				source:play()
			end,

			getCurrentSample = function(self)
				return getInterleavedSampleIndex(source)
			end,

			jumpToSample = function(self, sample)
				seekToInterleavedSample(source, sample)
			end,

			refreshVolume = function(self)
				source:setVolume(volume * volumeScalar)
			end,

            isPlaying = function(self)
                return source:isPlaying()
            end,

			update = function(self, dt)
				if delaySamples <= 0 or not syncSource or delaySec <= 0 then
					return
				end
				if source:isPlaying() then
					return
				end

				local leaderPlaying = syncSource:isPlaying()
				-- Arm once per dry start (rising edge), then count time with dt even if dry stops first.
				if not echoWaitArmed and leaderPlaying and not leaderWasPlaying then
					echoWaitArmed = true
					echoWaitElapsed = 0
				end
				leaderWasPlaying = leaderPlaying

				if not echoWaitArmed then
					return
				end

				echoWaitElapsed = echoWaitElapsed + dt
				if echoWaitElapsed < delaySec then
					return
				end

				local stride = streamStride()
				local startSec = (startPoint and startPoint > 0 and stride > 0) and (startPoint / stride) or 0
				local posSec = startSec + math.max(0, echoWaitElapsed - delaySec)
				local okDur, durOrErr = pcall(function() return source:getDuration() end)
				local dur = okDur and type(durOrErr) == "number" and durOrErr or nil
				if dur and dur > 0 and posSec > dur then
					posSec = math.max(0, dur)
				end

				source:seek(posSec, "seconds")
				self:refreshVolume()
				source:play()
				echoWaitArmed = false
				echoWaitElapsed = 0
				if self.chainPrime and self.chainPrime.primeFromSync then
					self.chainPrime:primeFromSync()
				end
				return true
			end,

			setVolumeScalar = function(self, v)
				volumeScalar = v
				self:refreshVolume()
			end,

			setVolume = function(self, v)
				volume = v
				self:refreshVolume()
			end,

			setPitch = function(self, p)
				pitch = p
				source:setPitch(pitch)
			end,

			stop = function(self)
				source:stop()
			end,
		}
	end,
}

local Track = {
	create = function(self, params)
		return ({
			filename     = params.filename,
			volume       = params.volume or 1,
			pitch        = params.pitch or 1,
			startPoint   = params.startPoint or 0,
			endPoint     = params.endPoint,
			reverse      = params.reverse,
			effect       = params.effect or { type = "None", },
            delay        = params.delay or 0,
			volumeScalar = 1,
			effectiveStartPoint = 0,
			queuedSounds = {},
			drySource    = nil,
			soundData    = nil,

			init = function(self)
				if self.effect.type == "Reverb" then
					return self:initReverbTrack()
				elseif self.effect.type == "Echo" then
					return self:initEchoTrack()
				else
					return self:initDryTrack()
				end
			end,

			initDryTrack = function(self)
				local path = relativePath("resources/sounds/") .. self.filename
				local playStart = self.startPoint or 0
				if self.reverse then
					local full = love.sound.newSoundData(path)
					self.soundData = sliceReverseSoundData(full, self.startPoint, self.endPoint, true)
					playStart = 0
				else
					self.soundData = love.sound.newSoundData(path)
				end
				self.effectiveStartPoint = playStart
				self.drySource = love.audio.newSource(self.soundData, "static")

				local sr = self.soundData:getSampleRate()
				local ch = self.soundData:getChannelCount()

				self.sound = Sound:create {
					source         = self.drySource,
					sampleRate     = sr,
					channelCount   = ch,
					volume         = self.volume,
					pitch          = self.pitch,
					startPoint     = self.effectiveStartPoint,
					volumeScalar   = self.volumeScalar,
				}

				return self
			end,

			initReverbTrack = function(self)
				self:initDryTrack()
				local reverbSource = love.audio.newSource(self.soundData, "static")

				local sr = self.soundData:getSampleRate()
				local ch = self.soundData:getChannelCount()

				local reverbSound = Sound:create {
					source       = reverbSource,
					sampleRate   = sr,
					channelCount = ch,
					volume       = self.volume * (self.effect.strength or 0.5),
					pitch        = self.pitch,
					startPoint   = self.effectiveStartPoint,
					volumeScalar = self.volumeScalar,
					-- Match musicManager:newReverbTrack (delay / 2 before sample conversion)
					delay        = math.floor(((self.effect.delay or 0) / 8) * sr * ch),
					syncSource   = self.drySource,
				}

				self.queuedSounds = {}
				table.insert(self.queuedSounds, reverbSound)

				return self
			end,

			initEchoTrack = function(self)
				self:initDryTrack()
				local sr = self.soundData:getSampleRate()
				local ch = self.soundData:getChannelCount()
				local strength = self.effect.strength or 0.5
				local echoCount = math.max(0, math.floor(self.effect.echoCount or 6))
				-- Per-hop delay in samples (same idea as musicManager:newEchoTrack delay * 4 → one factor here)
				local baseDelaySamples = math.floor((self.effect.delay or 0) * sr * ch)
				if echoCount > 0 and baseDelaySamples <= 0 then
					baseDelaySamples = 1
				end

				self.queuedSounds = {}
                local detuning = self.effect.detuning or 1
                local previousSource = self.drySource
				for i = 1, echoCount do
					local echoSrc = love.audio.newSource(self.soundData, "static")
					local echoVol = self.volume * (strength ^ i)
                    local currentPitch = self.pitch * (detuning ^ i)
					table.insert(self.queuedSounds, Sound:create {
						source       = echoSrc,
						sampleRate   = sr,
						channelCount = ch,
						volume       = echoVol,
						pitch        = currentPitch,
						startPoint   = self.effectiveStartPoint,
						volumeScalar = self.volumeScalar,
						delay        = baseDelaySamples,
						syncSource   = previousSource,
					})
					previousSource = echoSrc
				end

				for i = 1, echoCount - 1 do
					self.queuedSounds[i].chainPrime = self.queuedSounds[i + 1]
				end

				return self
			end,

			play = function(self, _)
				self.sound:play()
				if (self.effect.type == "Echo" or self.effect.type == "Reverb")
					and self.queuedSounds[1]
					and self.queuedSounds[1].primeFromSync then
					self.queuedSounds[1]:primeFromSync()
				end
			end,

            isPlaying = function(self)
                if self.sound:isPlaying() then 
                    return true
                else
                    for _, queuedSound in ipairs(self.queuedSounds) do
                        if queuedSound:isPlaying() then
                            return true
                        end
                    end
                end
            end,

			update = function(self, dt)
				for _, s in ipairs(self.queuedSounds) do
					s:update(dt)
				end
			end,

			setVolumeScalar = function(self, v)
				self.volumeScalar = v
				self.sound:setVolumeScalar(v)
				for _, s in ipairs(self.queuedSounds) do
					s:setVolumeScalar(v)
				end
			end,

			setVolume = function(self, volume)
				self.volume = volume
				self.sound:setVolume(volume)
				if self.effect.type == "Echo" then
					local strength = self.effect.strength or 0.5
					for i, s in ipairs(self.queuedSounds) do
						s:setVolume(volume * (strength ^ i))
					end
				elseif self.effect.type == "Reverb" and self.queuedSounds[1] then
					self.queuedSounds[1]:setVolume(volume * (self.effect.strength or 0.5))
				end
			end,

			setPitch = function(self, pitch)
				self.pitch = pitch
				self.sound:setPitch(pitch)
				if self.effect.type == "Echo" then
                    local detuning = self.effect.detuning or 1
                    for i, s in ipairs(self.queuedSounds) do
                        s:setPitch(pitch * (detuning ^ i))
                    end
                else
                    for _, s in ipairs(self.queuedSounds) do
                        s:setPitch(pitch)
                    end
			    end
            end,
		}):init()
	end,
}

return {
	create = function(_, params)
		if params.filename and params.source == nil then
			return Track:create(params)
		end
		return Sound:create(params)
	end,
}
