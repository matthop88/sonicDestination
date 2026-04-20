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
}

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
		local volumeSlider = nil
		local pitchSlider = nil
		
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
		}

		return ({
			x = params.x or 300,
			y = params.y or 250,
			width = params.width or 830,
			height = params.height or 400,
			visible = false,
				
			init = function(self)
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
						local selectedSound = soundDropDowns:getSelectedSound()
						if selectedSound.value ~= "None" then
							SOUND_MANAGER:play(selectedSound.value)
						end
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
						return getProperties().sounds.volume or 1.0
					end,
					setValue = function(value)
						getProperties().sounds = getProperties().sounds or {}
						getProperties().sounds.volume = value
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
						return getProperties().sounds.pitch or 1.0
					end,
					setValue = function(value)
						getProperties().sounds = getProperties().sounds or {}
						getProperties().sounds.pitch = value
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

				if volumeSlider:handleMousePressed(mx, my) then
					return true
				end
				
				if pitchSlider:handleMousePressed(mx, my) then
					return true
				end
				
			end,
			
			containsPoint = function(self, mx, my)
				return mx >= self.x and mx <= self.x + self.width and
				       my >= self.y and my <= self.y + self.height
			end,
							
			handleMouseReleased = function(self, mx, my)
				volumeSlider:handleMouseReleased()
				pitchSlider:handleMouseReleased()
			end,
				
			setVisible = function(self, visible)
				self.visible = visible
				if visible == false then
					actionDropDown:hideList()
					soundDropDowns:hide()
					self:resetMusic()
				else
					self:stopMusic()
				end
				soundDropDowns:show(actionDropDown:getSelectedValue())
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
								local properties = getProperties()
								if not properties.sounds then properties.sounds = {} end
								if item.value ~= "None" then
									SOUND_MANAGER:play(item.value)
									properties.sounds[actionDropDown:getSelectedValue().serial] = item.value
								else
									properties.sounds[actionDropDown:getSelectedValue().serial] = "None"
								end
							end,
						}
					soundDropDown.action = action
					local soundProperties = getProperties().sounds
					if soundProperties then
						if soundProperties[action.serial] then
							soundDropDown:setSelectedValue(soundProperties[action.serial])
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
