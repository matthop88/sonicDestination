local SOUND_DATA = require("game/sound/soundData")

local COLOR = require("tools/lib/colors")
local verticalSliderPane = require("tools/lib/components/verticalSliderPane")
local horizontalSlider = require("tools/lib/components/horizontalSlider")
local ACTIONS = { 
	{ serial = "braking",         label = "Braking" },
	{ serial = "jumping",         label = "Jumping" },
	{ serial = "collectOddRing",  label = "Collect Odd Ring" },
	{ serial = "collectEvenRing", label = "Collect Even Ring" }, 
	{ serial = "giantRing",       label = "Giant Ring" },
	{ serial = "vanish",          label = "Vanish" },
	{ serial = "sonicHit",        label = "Sonic Hit" },
	{ serial = "badnikHit",       label = "Badnik Hit" },
	{ serial = "ballThud",        label = "Ball Landing" },
}

local AUDIO_EFFECTS = {
	{ label = "None",   value = "None" },
	{ label = "Reverb", value = "Reverb" },
	{ label = "Echo",   value = "Echo" },
}

local ECHO_COUNT_ITEMS = {}
for n = 0, 10 do
	local s = tostring(n)
	table.insert(ECHO_COUNT_ITEMS, { label = s, value = s })
end

local function ensureSoundActionProps(serial)
	local p = getProperties()
	if not p.sounds then p.sounds = {} end
	if not p.sounds[serial] then p.sounds[serial] = {} end
	return p.sounds[serial]
end

local buildSeparator = function(self)
	local RECTANGLE_ITEM = require("tools/lib/guiList/rectangleItem")
	return RECTANGLE_ITEM:create {
		color = { 0.5, 0.5, 0.5 },
		width = 390,
		height = 5,
		notSelectable = true,
	}
end

return {
	create = function(self, params)
		local okButton       = nil
		local actionDropDown = nil
		local effectDropDown = nil
		local echoDropDown   = nil
		local delaySlider    = nil
		local strengthSlider = nil
		local detuningSlider = nil
		local volumeSlider = nil
		local pitchSlider = nil

		local selectedAudioEffectName = function()
			local item = effectDropDown:getSelectedValue()
			if type(item) == "table" then return item.value or "None" end
			return "None"
		end

		local actionProps

		local resetFxControls = function()
			local sp = actionProps()
			local eff = sp.audioEffect or "None"
			effectDropDown:setSelectedValue(eff)
			echoDropDown:setSelectedValue(tostring(sp.echoCount ~= nil and sp.echoCount or 6))
			echoDropDown:setVisible(eff == "Echo")
		end
		
		local soundDropDowns = {
			draw = function(self) 
				for _, v in ipairs(self) do v:draw() end
			end,

			update = function(self, dt, mx, my)
				for _, v in ipairs(self) do v:update(dt, mx, my) end
			end,

			handleMousepressed = function(self, mx, my)
				for _, v in ipairs(self) do 
					if v:handleMousepressed(mx, my) then return true end
				end
			end,

			show = function(self, action)
				for _, v in ipairs(self) do
					if v.action == action then v:setVisible(true)
					else                       v:setVisible(false)
					end
				end
			end,

			hide = function(self)
				for _, v in ipairs(self) do v:setVisible(false) end
			end,

			getSelectedSound = function(self)
				for _, v in ipairs(self) do
					if v.visible then
						return v:getSelectedValue()
					end
				end
			end,

		}

		local soundRecommendations = {
			braking         = { "Sonic Braking", "Sneakers" },
			jumping         = { "Sonic Jumping", "Sonic CD Jumping" },
			collectOddRing  = { "Ring Collect L" },
			collectEvenRing = { "Ring Collect R" },
			giantRing       = { "Giant Ring" },
			vanish          = { "Vanish" },
			sonicHit        = { "Sonic Hit", "Ice Explode", "Klank Ouch!" },
			badnikHit       = { "Badnik Death", "Smoosh", "Bowling Strike" },
			ballThud        = { "Thud" },
		}

		local playSelectedSound = function()
			local selectedSound = soundDropDowns:getSelectedSound()
			if selectedSound.value ~= "None" then
				local sound = SOUND_MANAGER:getByName(selectedSound.value)
				sound:setVolume(volumeSlider:getValue())
				sound:setPitch(pitchSlider:getValue())
									
				SOUND_MANAGER:play(selectedSound.value)
			end
		end

		local rebuildSoundForSelection = function()
			local selectedSound = soundDropDowns:getSelectedSound()
			if not selectedSound or selectedSound.value == "None" then return end
			SOUND_MANAGER:rebuildSound(selectedSound.value)
			playSelectedSound()
		end

		local resetSliders = function()
			local sp = actionProps()
			volumeSlider.setValue(sp.volume or 1)
			pitchSlider.setValue(sp.pitch or 1)
			resetFxControls()
		end

		-- Panel runs before list modals. Use this for hits inside an open list so lower fields /
		-- sliders (which overlap lists visually) do not steal the press.
		local function openDropDownListContainsPoint(mx, my)
			local function listHit(l)
				if not l or not l.visible then return false end
				if l.listBoxContainsPt then
					return l:listBoxContainsPt(mx, my)
				end
				return mx >= l.x and mx <= l.x + l.width and my >= l.y and my <= l.y + l.height
			end
			for _, dd in ipairs({ actionDropDown, effectDropDown, echoDropDown }) do
				if dd and dd.list and listHit(dd.list) then
					return true
				end
			end
			for _, dd in ipairs(soundDropDowns) do
				if dd.list and listHit(dd.list) then
					return true
				end
			end
			return false
		end

		return ({
			x = params.x or 300,
			y = params.y or 250,
			width = params.width or 830,
			height = params.height or 470,
			visible = false,
				
			init = function(self)
				if _G.getModals then
					getModals():add(self)
				end

				okButton = require("tools/lib/components/okButton"):create {
					x = self.x + self.width - 120,
					y = self.y + self.height - 60,
					width = 100,
					height = 40,
				}

				actionDropDown = require("tools/lib/components/dropDownField"):create {
					x = self.x + 20,
					y = self.y + 80,
					width = 300,
					height = 50,
					list = ACTIONS,
					selectedIndex = 1,
					comparisonFn = function(listItem, value) return listItem.label == value end,
					onChanged = function(item, index)
						soundDropDowns:show(item)
						resetSliders()
						rebuildSoundForSelection()
					end,
				}

				actionProps = function()
					return ensureSoundActionProps(actionDropDown:getSelectedValue().serial)
				end

				effectDropDown = require("tools/lib/components/dropDownField"):create {
					x = self.x + 20,
					y = self.y + 140,
					width = 300,
					height = 50,
					label = "Effect",
					list = AUDIO_EFFECTS,
					selectedIndex = 1,
					comparisonFn = function(listItem, value)
						return listItem.value == value
					end,
					onChanged = function(item, index)
						local sp = actionProps()
						sp.audioEffect = item.value
						echoDropDown:setVisible(item.value == "Echo")
						rebuildSoundForSelection()
					end,
				}

				echoDropDown = require("tools/lib/components/dropDownField"):create {
					x = self.x + 20,
					y = self.y + 190,
					width = 300,
					height = 50,
					label = "Echo Count",
					list = ECHO_COUNT_ITEMS,
					selectedIndex = 7,
					visible = false,
					comparisonFn = function(listItem, value)
						return listItem.value == value
					end,
					onChanged = function(item, index)
						actionProps().echoCount = tonumber(item.value)
						rebuildSoundForSelection()
					end,
				}

				delaySlider = horizontalSlider:create {
					x = self.x + 20,
					y = self.y + 250,
					width = self.width - 190,
					height = 50,
					title = "Delay",
					minValue = 0.0,
					maxValue = 1.0,
					quantize = 0.1,
					titleFontSize = 16,
					labelFontSize = 16,
					getValue = function()
						local sp = actionProps()
						return sp.delay ~= nil and sp.delay or 0.5
					end,
					setValue = function(value)
						actionProps().delay = value
					end,
				}

				strengthSlider = horizontalSlider:create {
					x = self.x + 20,
					y = self.y + 300,
					width = self.width - 190,
					height = 50,
					title = "Strength",
					minValue = 0.0,
					maxValue = 1.0,
					quantize = 0.1,
					titleFontSize = 16,
					labelFontSize = 16,
					getValue = function()
						local sp = actionProps()
						return sp.strength ~= nil and sp.strength or 0.5
					end,
					setValue = function(value)
						actionProps().strength = value
					end,
				}

				detuningSlider = horizontalSlider:create {
					x = self.x + 20,
					y = self.y + 350,
					width = self.width - 190,
					height = 50,
					title = "Detuning",
					minValue = 0.8,
					maxValue = 1.2,
					quantize = 0.02,
					titleFontSize = 16,
					labelFontSize = 16,
					getValue = function()
						local sp = actionProps()
						return sp.detuning ~= nil and sp.detuning or 1.0
					end,
					setValue = function(value)
						actionProps().detuning = value
					end,
				}

				volumeSlider = verticalSliderPane:create {
					x = self.x + self.width - 150,
					y = self.y + 60,
					width = 60,
					height = self.height - 140,
					title = "Volume",
					minValue = 0,
					maxValue = 1,
					quantize = 0.1,
					titleFontSize = 14,
					labelFontSize = 16,
					showLabels = false,
					getValue = function()
						local sp = actionProps()
						return sp.volume or 1.0
					end,
					setValue = function(value)
						local selectedSound = soundDropDowns:getSelectedSound()
						local sp = actionProps()
						sp.volume = value
						sp.sound = selectedSound.value
					end,
				}
				
				pitchSlider = verticalSliderPane:create {
					x = self.x + self.width - 70,
					y = self.y + 60,
					width = 60,
					height = self.height - 140,
					title = "Pitch",
					minValue = 0.75,
					maxValue = 1.5,
					quantize = 0.05,
					titleFontSize = 14,
					labelFontSize = 16,
					showLabels = false,
					getValue = function()
						local sp = actionProps()
						return sp.pitch or 1.0
					end,
					setValue = function(value)
						local selectedSound = soundDropDowns:getSelectedSound()
						local sp = actionProps()
						sp.pitch = value
						sp.sound = selectedSound.value
					end,
				}

				self:buildSoundDropDowns()
		
				return self
			end,
					
			draw = function(self)
				if not self.visible then return end
				
				self:drawPanelBackground()
				self:drawTitle()
				actionDropDown:draw()
				soundDropDowns:draw()
				effectDropDown:draw()
				if selectedAudioEffectName() == "Echo" then
					echoDropDown:draw()
				end
				if selectedAudioEffectName() ~= "None" then
					delaySlider:draw()
					strengthSlider:draw()
				end
				if selectedAudioEffectName() == "Echo" then
					detuningSlider:draw()
				end
				do
					-- Same x as sound dropdown; vertically centered with Effect row (y+140, height 50)
					local bx, by = self.x + 340, self.y + 156
					love.graphics.setColor(COLOR.PURE_WHITE)
					love.graphics.rectangle("line", bx, by, 18, 18)
					if actionProps().reverse == true then
						love.graphics.setColor(COLOR.YELLOW)
						love.graphics.rectangle("fill", bx + 3, by + 3, 12, 12)
						love.graphics.setColor(COLOR.PURE_WHITE)
					end
					love.graphics.print("Reverse", bx + 24, by + 1)
				end
				volumeSlider:draw()
				pitchSlider:draw()
				okButton:draw()
			end,
			
			drawPanelBackground = function(self)
				love.graphics.setColor(COLOR.DARK_GREY)
				love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
				love.graphics.setColor(COLOR.PURE_WHITE)
				love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
			end,
			
			drawTitle = function(self)
				love.graphics.setColor(COLOR.PURE_WHITE)
				local font = love.graphics.newFont(24)
				love.graphics.setFont(font)
				love.graphics.printf("Select Action", self.x, self.y + 20, self.width, "center")
			end,
							
			update = function(self, dt)
				if not self.visible then return end
				
				local mx, my = love.mouse.getPosition()
				okButton:update(mx, my)
				actionDropDown:update(dt, mx, my)
				soundDropDowns:update(dt, mx, my)
				effectDropDown:update(dt, mx, my)
				if selectedAudioEffectName() == "Echo" then
					echoDropDown:update(dt, mx, my)
				end
				if selectedAudioEffectName() ~= "None" then
					delaySlider:update(dt)
					strengthSlider:update(dt)
				end
				if selectedAudioEffectName() == "Echo" then
					detuningSlider:update(dt)
				end
				volumeSlider:update(dt)
				pitchSlider:update(dt)
				
			end,
								
			handleMousePressed = function(self, mx, my)
				if not self.visible then return false end
				
				if okButton:containsPoint(mx, my) then
					self:setVisible(false)
					return true
				end

				if actionDropDown:handleMousepressed(mx, my) then
					return true
				end

				if soundDropDowns:handleMousepressed(mx, my) then
					return true
				end

				-- Lists are separate modal components registered after this panel. A list draws over
				-- fields below it (e.g. action list y>=130 overlaps the effect field y=140–190); field
				-- hit-tests would steal those clicks unless we defer to the list modals first.
				if openDropDownListContainsPoint(mx, my) then
					return false
				end

				if effectDropDown:handleMousepressed(mx, my) then
					return true
				end

				if selectedAudioEffectName() == "Echo" and echoDropDown:handleMousepressed(mx, my) then
					return true
				end

				if selectedAudioEffectName() ~= "None" then
					if delaySlider:handleMousePressed(mx, my) then
						return true
					end
					if strengthSlider:handleMousePressed(mx, my) then
						return true
					end
				end
				if selectedAudioEffectName() == "Echo" then
					if detuningSlider:handleMousePressed(mx, my) then
						return true
					end
				end

				if volumeSlider:handleMousePressed(mx, my) then
					return true
				end

				if pitchSlider:handleMousePressed(mx, my) then
					return true
				end

				local rbx, rby = self.x + 340, self.y + 156
				if mx >= rbx and mx <= rbx + 100 and my >= rby and my <= rby + 22 then
					local sp = actionProps()
					sp.reverse = not (sp.reverse == true)
					rebuildSoundForSelection()
					return true
				end

			end,
			
			containsPoint = function(self, mx, my)
				return mx >= self.x and mx <= self.x + self.width and
				       my >= self.y and my <= self.y + self.height
			end,
							
			handleMouseReleased = function(self, mx, my)
				if not self.visible then return end
				local delayDone, strengthDone = false, false
				if selectedAudioEffectName() ~= "None" then
					delayDone = delaySlider:handleMouseReleased()
					strengthDone = strengthSlider:handleMouseReleased()
				else
					delaySlider:handleMouseReleased()
					strengthSlider:handleMouseReleased()
				end
				local detuningDone = false
				if selectedAudioEffectName() == "Echo" then
					detuningDone = detuningSlider:handleMouseReleased()
				else
					detuningSlider:handleMouseReleased()
				end
				if selectedAudioEffectName() ~= "None" and (delayDone or strengthDone or detuningDone) then
					rebuildSoundForSelection()
				end
				if volumeSlider:handleMouseReleased() then
					playSelectedSound()
				elseif pitchSlider:handleMouseReleased() then
					playSelectedSound()
				end
			end,
				
			setVisible = function(self, visible)
				self.visible = visible
				if visible == false then
					actionDropDown:hideList()
					effectDropDown:hideList()
					echoDropDown:hideList()
					soundDropDowns:hide()
					self:resetMusic()
				else
					self:stopMusic()
				end
				soundDropDowns:show(actionDropDown:getSelectedValue())
				if visible then
					resetSliders()
					local sel = soundDropDowns:getSelectedSound()
					if sel and sel.value ~= "None" then
						SOUND_MANAGER:rebuildSound(sel.value)
					end
				end
			end,

			resetMusic = function(self)
				MUSIC_MANAGER:clear()
				MUSIC_MANAGER:newTrack("constructionSet")
				MUSIC_MANAGER:setVolume(1.0)
				MUSIC_MANAGER:setPitch(1.0)
				MUSIC_MANAGER:play()
			end,

			stopMusic = function(self)
				MUSIC_MANAGER:clear()
			end,

			buildSoundDropDowns = function(self)
				for _, action in ipairs(ACTIONS) do
					local recommendations = soundRecommendations[action.serial] or {}

					local soundDropDown = 
						require("tools/lib/components/dropDownField"):create {
							x = self.x + 340,
							y = self.y + 80,
							width = 300,
							height = 50,
							list = self:buildSoundItems(recommendations),
							visible = false,
							selectedIndex = 2,
							comparisonFn = function(listItem, value) return listItem.value == value end,
							onChanged    = function(item, index)
								local sp = actionProps()
								if item.value ~= "None" then
									sp.sound = item.value
									SOUND_MANAGER:rebuildSound(item.value)
									local sound = SOUND_MANAGER:getByName(item.value)
									sound:setVolume(volumeSlider:getValue())
									sound:setPitch(pitchSlider:getValue())
									SOUND_MANAGER:play(item.value)
								else
									sp.sound = "None"
								end
							end,
						}
					soundDropDown.action = action
					local soundProperties = getProperties().sounds
					if soundProperties then
						if soundProperties[action.serial] then
							soundDropDown:setSelectedValue(soundProperties[action.serial].sound)
						end
					end

					table.insert(soundDropDowns, soundDropDown)
				end
			end,

			buildSoundItems = function(self, recommendations)
				local items = {}
				
				table.insert(items, { label = "None", value = "None" })
				for _, r in ipairs(recommendations) do
					for soundKey, soundInfo in pairs(SOUND_DATA) do
						if soundInfo.label == r then 
							table.insert(items, { label = soundInfo.label, value = soundKey })
						end
					end
				end
				table.insert(items, buildSeparator())
				for soundKey, soundInfo in pairs(SOUND_DATA) do
					local matchesRecommendation = false
					for _, r in ipairs(recommendations) do
						if soundInfo.label == r then 
							matchesRecommendation = true
						end
					end
					if not matchesRecommendation then
						table.insert(items, { label = soundInfo.label, value = soundKey })
					end
				end

				return items
			end,
		
		}):init()
	end,
}
