local COLOR = require("tools/lib/colors")
local verticalSliderPane = require("tools/lib/components/verticalSliderPane")
local horizontalSlider = require("tools/lib/components/horizontalSlider")
local echoCountList = require("tools/constructionSet/miscellaneous/music/echoCountList")

local createField = function(params)
	return {
		x = params.x,
		y = params.y,
		width = params.width,
		height = params.height or 50,
		label = params.label or "",
		selectedValue = params.selectedValue or "None",
		hovered = false,
		
		draw = function(self)
			-- Draw field background
			if self.hovered then
				love.graphics.setColor(COLOR.LIGHTER_GREY)
			else
				love.graphics.setColor(COLOR.MEDIUM_DARK_GREY)
			end
			love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
			love.graphics.setColor(COLOR.PURE_WHITE)
			love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
			
			-- Draw label and selected value
			love.graphics.setColor(COLOR.PURE_WHITE)
			local fieldFont = love.graphics.newFont(20)
			love.graphics.setFont(fieldFont)
			
			if self.label and self.label ~= "" then
				love.graphics.print(self.label .. ":", self.x + 10, self.y + 15)
				local labelWidth = fieldFont:getWidth(self.label .. ": ")
				love.graphics.print(self.selectedValue, self.x + 10 + labelWidth, self.y + 15)
			else
				love.graphics.printf(self.selectedValue, self.x + 10, self.y + 15, self.width - 20, "left")
			end
		end,
		
		update = function(self, mx, my)
			self.hovered = self:containsPoint(mx, my)
		end,
		
		containsPoint = function(self, mx, my)
			return mx >= self.x and mx <= self.x + self.width and
			       my >= self.y and my <= self.y + self.height
		end,
		
		setSelectedValue = function(self, value)
			self.selectedValue = value
		end,
	}
end

local createMusicNameField = function(params)
	params.label = ""
	params.selectedValue = params.selectedTrack
	local field = createField(params)
	field.setSelectedTrack = function(self, track)
		self:setSelectedValue(track)
	end
	field.getSelectedTrack = function(self)
		return self.selectedValue
	end
	return field
end

local changeMusicTrack = function(trackName, effectName, echoCount)
	MUSIC_MANAGER:clear()
	if trackName ~= "None" then
		MUSIC_MANAGER:newTrack(trackName, effectName, getProperties().musicDelay or 0.5, getProperties().musicStrength or 0.5, echoCount or 6)
		local volume = getProperties().musicVolume or 1.0
		local pitch = getProperties().musicPitch or 1.0
		MUSIC_MANAGER:setVolume(volume)
		MUSIC_MANAGER:setPitch(pitch)
		MUSIC_MANAGER:play()
	end
end	

local resetMusicTrack = function()
	MUSIC_MANAGER:clear()
	MUSIC_MANAGER:newTrack("constructionSet")
	MUSIC_MANAGER:setVolume(1.0)
	MUSIC_MANAGER:setPitch(1.0)
	MUSIC_MANAGER:play()
end
				
return {
	create = function(self, params)
		local selectedTrack = getProperties().music or "None"
		local selectedEffect = getProperties().musicEffect or "None"
		local selectedEchoCount = tostring(getProperties().musicEchoCount or 6)
		local selectedDelay = getProperties().musicDelay or 0.5
		local selectedStrength = getProperties().musicStrength or 0.5
		local onTrackChanged = params.onTrackChanged
		local musicList = nil
		local effectList = nil
		local echoCountList = nil
		local musicNameField = nil
		local effectField = nil
		local echoCountField = nil
		local delaySlider = nil
		local strengthSlider = nil
		local okButton = nil
		local volumeSlider = nil
		local pitchSlider = nil
			
		return ({
			x = params.x or 300,
			y = params.y or 250,
			width = params.width or 830,
			height = params.height or 400,
			visible = false,
				
			init = function(self)
				musicNameField = createMusicNameField {
					x = self.x + 20,
					y = self.y + 80,
					width = self.width - 190,
					height = 50,
					selectedTrack = selectedTrack,
				}
							
				effectField = createField {
					x = self.x + 20,
					y = self.y + 140,
					width = self.width - 190,
					height = 50,
					label = "Effect",
					selectedValue = selectedEffect,
				}
				
				echoCountField = createField {
					x = self.x + 20,
					y = self.y + 190,
					width = self.width - 190,
					height = 50,
					label = "Echo Count",
					selectedValue = selectedEchoCount,
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
						return getProperties().musicDelay or 0.5
					end,
					setValue = function(value)
						getProperties().musicDelay = value
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
						return getProperties().musicStrength or 0.5
					end,
					setValue = function(value)
						getProperties().musicStrength = value
					end,
				}
				
				volumeSlider = verticalSliderPane:create {
					x = self.x + self.width - 150,
					y = self.y + 60,
					width = 60,
					height = self.height - 140,
					title = "Volume",
					minValue = 0,
					maxValue = 2,
					quantize = 0.05,
					titleFontSize = 14,
					labelFontSize = 16,
					showLabels = false,
					getValue = function()
						return getProperties().musicVolume or 1.0
					end,
					setValue = function(value)
						getProperties().musicVolume = value
						MUSIC_MANAGER:setVolume(value)
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
						return getProperties().musicPitch or 1.0
					end,
					setValue = function(value)
						getProperties().musicPitch = value
						MUSIC_MANAGER:setPitch(value)
					end,
				}
				
				okButton = require("tools/lib/components/okButton"):create {
					x = self.x + self.width - 120,
					y = self.y + self.height - 60,
					width = 100,
					height = 40,
				}
		
				local oldOnTrackChanged = onTrackChanged
		
				onTrackChanged = function(trackName)
					changeMusicTrack(trackName, selectedEffect, tonumber(selectedEchoCount))
					oldOnTrackChanged(trackName)
				end
					
				return self
			end,
					
			draw = function(self)
				if not self.visible then return end
				
				self:drawPanelBackground()
				self:drawTitle()
				musicNameField:draw()
				effectField:draw()
				
				if selectedEffect == "Echo" then
					echoCountField:draw()
				end
				
				if selectedEffect ~= "None" then
					delaySlider:draw()
					strengthSlider:draw()
				end
				
				volumeSlider:draw()
				pitchSlider:draw()
				okButton:draw()
				
				if musicList and musicList:isVisible() then
					musicList:draw()
				end
				
				if effectList and effectList:isVisible() then
					effectList:draw()
				end
				
				if echoCountList and echoCountList:isVisible() then
					echoCountList:draw()
				end
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
				love.graphics.printf("Select Music Track", self.x, self.y + 20, self.width, "center")
			end,
							
			update = function(self, dt)
				if not self.visible then return end
				
				local mx, my = love.mouse.getPosition()
				musicNameField:update(mx, my)
				effectField:update(mx, my)
				
				if selectedEffect == "Echo" then
					echoCountField:update(mx, my)
				end
				
				okButton:update(mx, my)
				
				if selectedEffect ~= "None" then
					delaySlider:update(dt)
					strengthSlider:update(dt)
				end
				
				volumeSlider:update(dt)
				pitchSlider:update(dt)
				
				if musicList and musicList:isVisible() then
					musicList:update(dt, mx, my)
				end
				
				if effectList and effectList:isVisible() then
					effectList:update(dt, mx, my)
				end
				
				if echoCountList and echoCountList:isVisible() then
					echoCountList:update(dt, mx, my)
				end
			end,
								
			handleMousePressed = function(self, mx, my)
				if not self.visible then return false end
				
				if musicList and musicList:isVisible() then
					return false
				end
				
				if effectList and effectList:isVisible() then
					return false
				end
				
				if echoCountList and echoCountList:isVisible() then
					return false
				end
				
				if selectedEffect ~= "None" then
					if delaySlider:handleMousePressed(mx, my) then
						return true
					end
					
					if strengthSlider:handleMousePressed(mx, my) then
						return true
					end
				end
				
				if volumeSlider:handleMousePressed(mx, my) then
					return true
				end
				
				if pitchSlider:handleMousePressed(mx, my) then
					return true
				end
				
				if self:containsPoint(mx, my) then
					if musicNameField:containsPoint(mx, my) then
						self:showMusicList()
					end
					
					if effectField:containsPoint(mx, my) then
						self:showEffectList()
					end
					
					if selectedEffect == "Echo" and echoCountField:containsPoint(mx, my) then
						self:showEchoCountList()
					end
					
					if okButton:containsPoint(mx, my) then
						self:setVisible(false)
					end
					
					return true
				end
				
				return false
			end,
			
			containsPoint = function(self, mx, my)
				return mx >= self.x and mx <= self.x + self.width and
				       my >= self.y and my <= self.y + self.height
			end,
							
			handleMouseReleased = function(self, mx, my)
				volumeSlider:handleMouseReleased()
				pitchSlider:handleMouseReleased()
				
				if selectedEffect ~= "None" then
					delaySlider:handleMouseReleased()
					strengthSlider:handleMouseReleased()
					if (selectedDelay ~= getProperties().musicDelay and getProperties().musicDelay) or (selectedStrength ~= getProperties().musicStrength and getProperties().musicStrength) then
						changeMusicTrack(musicNameField:getSelectedTrack(), selectedEffect, tonumber(selectedEchoCount))
						selectedDelay = getProperties().musicDelay
						selectedStrength = getProperties().musicStrength
					end
				end
			end,
				
			setVisible = function(self, visible)
				self.visible = visible
				if self.visible then
					changeMusicTrack(musicNameField:getSelectedTrack(), selectedEffect, tonumber(selectedEchoCount))
				else
					resetMusicTrack()
				end
			end,
					
			showMusicList = function(self)
				if not musicList then
					musicList = require("tools/constructionSet/miscellaneous/music/musicList"):create {
						x = musicNameField.x,
						y = musicNameField.y + musicNameField.height,
						width = musicNameField.width,
						height = 400,
						fontSize = 24,
						scrollSpeed = 1200,
						onMusicTrackSelected = function(item, index)
							selectedTrack = item or "None"
							musicNameField:setSelectedTrack(selectedTrack)
							if getProperties().music ~= selectedTrack and onTrackChanged then
								onTrackChanged(selectedTrack)
							end
						end,
					}
					
					if _G.getModals then
						getModals():add(musicList)
					end
				end
				
				musicList:setVisible(true)
			end,
			
		showEffectList = function(self)
			if not effectList then
				effectList = require("tools/constructionSet/miscellaneous/music/effectList"):create {
					x = effectField.x,
					y = effectField.y + effectField.height,
					width = effectField.width,
					height = 150,
					fontSize = 20,
					onEffectSelected = function(item, index)
						selectedEffect = item or "None"
						effectField:setSelectedValue(selectedEffect)
						getProperties().musicEffect = selectedEffect ~= "None" and selectedEffect or nil
						onTrackChanged(getProperties().music)
					end,
				}
				
				if _G.getModals then
					getModals():add(effectList)
				end
			end
			
			effectList:setVisible(true)
		end,
		
		showEchoCountList = function(self)
			if not echoCountList then
				echoCountList = require("tools/constructionSet/miscellaneous/music/echoCountList"):create {
					x = echoCountField.x,
					y = echoCountField.y + echoCountField.height,
					width = echoCountField.width,
					maxHeight = 250,
					onEchoCountSelected = function(item, index)
						selectedEchoCount = item
						echoCountField:setSelectedValue(selectedEchoCount)
						getProperties().musicEchoCount = tonumber(selectedEchoCount)
						local trackName = musicNameField:getSelectedTrack()
						changeMusicTrack(trackName, selectedEffect, tonumber(selectedEchoCount))
					end,
				}
				
				if _G.getModals then
					getModals():add(echoCountList)
				end
			end
			
			echoCountList:setVisible(true)
		end,
	}):init()
end,
}
