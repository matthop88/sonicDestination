local COLOR = require("tools/lib/colors")
local verticalSliderPane = require("tools/lib/components/verticalSliderPane")

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

local createOkButton = function(params)
	return {
		x = params.x,
		y = params.y,
		width = params.width or 100,
		height = params.height or 40,
		hovered = false,
		cornerRadius = 10,
		
		draw = function(self)
			if self.hovered then
				love.graphics.setColor(COLOR.MEDIUM_GREY)
			else
				love.graphics.setColor(COLOR.MEDIUM_DARK_GREY)
			end
			love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.cornerRadius, self.cornerRadius)
			love.graphics.setColor(COLOR.PURE_WHITE)
			love.graphics.rectangle("line", self.x, self.y, self.width, self.height, self.cornerRadius, self.cornerRadius)
			
			love.graphics.printf("OK", self.x, self.y + 10, self.width, "center")
		end,
		
		update = function(self, mx, my)
			self.hovered = self:containsPoint(mx, my)
		end,
		
		containsPoint = function(self, mx, my)
			return mx >= self.x and mx <= self.x + self.width and
			       my >= self.y and my <= self.y + self.height
		end,
	}
end

local changeMusicTrack = function(trackName)
	MUSIC_MANAGER:clear()
	if trackName ~= "None" then
		MUSIC_MANAGER:newTrack(trackName)
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
		local selectedTrack = params.initialTrack or "None"
		local selectedEffect = getProperties().musicEffect or "None"
		local onTrackChanged = params.onTrackChanged
		local musicList = nil
		local effectList = nil
		local musicNameField = nil
		local effectField = nil
		local okButton = nil
		local volumeSlider = nil
		local pitchSlider = nil
		
		return ({
			x = params.x or 300,
			y = params.y or 250,
			width = params.width or 830,
			height = params.height or 450,
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
				
				okButton = createOkButton {
					x = self.x + self.width - 120,
					y = self.y + self.height - 60,
					width = 100,
					height = 40,
				}
	
				local oldOnTrackChanged = onTrackChanged
	
				onTrackChanged = function(trackName)
					changeMusicTrack(trackName)
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
				love.graphics.printf("Select Music Track", self.x, self.y + 20, self.width, "center")
			end,
					
			update = function(self, dt)
				if not self.visible then return end
				
				local mx, my = love.mouse.getPosition()
				musicNameField:update(mx, my)
				effectField:update(mx, my)
				okButton:update(mx, my)
				volumeSlider:update(dt)
				pitchSlider:update(dt)
			end,
						
			handleMousePressed = function(self, mx, my)
				if not self.visible then return false end
				
				if musicList and musicList:isVisible() then
					return false
				end
				
				if effectList and effectList:isVisible() then
					return false
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
			end,
				
			setVisible = function(self, visible)
				self.visible = visible
				if self.visible then
					changeMusicTrack(musicNameField:getSelectedTrack())
				else
					resetMusicTrack()
				end
			end,
				
			showMusicList = function(self)
				if not musicList then
					musicList = require("tools/constructionSet/music/musicList"):create {
						x = musicNameField.x,
						y = musicNameField.y + musicNameField.height,
						width = musicNameField.width,
						height = 400,
						fontSize = 24,
						scrollSpeed = 1200,
						onMusicTrackSelected = function(item, index)
							selectedTrack = item or "None"
							musicNameField:setSelectedTrack(selectedTrack)
							if onTrackChanged then
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
					effectList = require("tools/constructionSet/music/effectList"):create {
						x = effectField.x,
						y = effectField.y + effectField.height,
						width = effectField.width,
						height = 150,
						fontSize = 20,
						onEffectSelected = function(item, index)
							selectedEffect = item or "None"
							effectField:setSelectedValue(selectedEffect)
							getProperties().musicEffect = selectedEffect ~= "None" and selectedEffect or nil
						end,
					}
					
					if _G.getModals then
						getModals():add(effectList)
					end
				end
				
				effectList:setVisible(true)
			end,
		}):init()
	end,
}
