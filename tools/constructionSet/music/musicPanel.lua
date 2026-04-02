local COLOR = require("tools/lib/colors")

return {
	create = function(self, params)
		local selectedTrack = params.initialTrack or "None"
		local onTrackChanged = params.onTrackChanged
		local musicList = nil
		
		return ({
			x = params.x or 300,
			y = params.y or 250,
			width = params.width or 600,
			height = params.height or 300,
			visible = false,
			
			-- Field properties
			fieldX = 0,
			fieldY = 0,
			fieldWidth = 0,
			fieldHeight = 50,
			
			-- OK button properties
			okButtonWidth = 100,
			okButtonHeight = 40,
			okButtonHovered = false,
			
			init = function(self)
				self.fieldX = self.x + 20
				self.fieldY = self.y + 80
				self.fieldWidth = self.width - 40
				return self
			end,
			
			draw = function(self)
				if not self.visible then return end
				
				-- Draw panel background
				love.graphics.setColor(0.2, 0.2, 0.2)
				love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
				love.graphics.setColor(1, 1, 1)
				love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
				
				-- Draw title
				love.graphics.setColor(1, 1, 1)
				local font = love.graphics.newFont(24)
				love.graphics.setFont(font)
				love.graphics.printf("Select Music Track", self.x, self.y + 20, self.width, "center")
				
				-- Draw field
				love.graphics.setColor(0.3, 0.3, 0.3)
				love.graphics.rectangle("fill", self.fieldX, self.fieldY, self.fieldWidth, self.fieldHeight)
				love.graphics.setColor(1, 1, 1)
				love.graphics.rectangle("line", self.fieldX, self.fieldY, self.fieldWidth, self.fieldHeight)
				
				-- Draw selected track name
				love.graphics.setColor(1, 1, 1)
				local fieldFont = love.graphics.newFont(20)
				love.graphics.setFont(fieldFont)
				love.graphics.printf(selectedTrack, self.fieldX + 10, self.fieldY + 15, self.fieldWidth - 20, "left")
				
				-- Draw OK button
				local okX = self.x + self.width - self.okButtonWidth - 20
				local okY = self.y + self.height - self.okButtonHeight - 20
				
				if self.okButtonHovered then
					love.graphics.setColor(0.5, 0.5, 0.5)
				else
					love.graphics.setColor(0.3, 0.3, 0.3)
				end
				love.graphics.rectangle("fill", okX, okY, self.okButtonWidth, self.okButtonHeight)
				love.graphics.setColor(1, 1, 1)
				love.graphics.rectangle("line", okX, okY, self.okButtonWidth, self.okButtonHeight)
				
				-- Draw OK text
				love.graphics.printf("OK", okX, okY + 10, self.okButtonWidth, "center")
			end,
			
			update = function(self, dt)
				if not self.visible then return end
				
				-- Update OK button hover state
				local mx, my = love.mouse.getPosition()
				local okX = self.x + self.width - self.okButtonWidth - 20
				local okY = self.y + self.height - self.okButtonHeight - 20
				self.okButtonHovered = mx >= okX and mx <= okX + self.okButtonWidth and
									   my >= okY and my <= okY + self.okButtonHeight
			end,
			
			handleMousePressed = function(self, mx, my)
				if not self.visible then return false end
				
				-- If music list is visible, don't consume the event
				if musicList and musicList:isVisible() then
					return false
				end
				
				-- Check if clicked inside panel
				if mx >= self.x and mx <= self.x + self.width and
				   my >= self.y and my <= self.y + self.height then
					
					-- Check if clicked on field
					if mx >= self.fieldX and mx <= self.fieldX + self.fieldWidth and
					   my >= self.fieldY and my <= self.fieldY + self.fieldHeight then
						self:showMusicList()
						return true
					end
					
					-- Check if clicked on OK button
					local okX = self.x + self.width - self.okButtonWidth - 20
					local okY = self.y + self.height - self.okButtonHeight - 20
					if mx >= okX and mx <= okX + self.okButtonWidth and
					   my >= okY and my <= okY + self.okButtonHeight then
						self:setVisible(false)
						return true
					end
					
					return true
				end
				
				return false
			end,
			
			handleMouseReleased = function(self, mx, my)
				if not self.visible then return end
				
				-- If music list is visible, don't consume the event
				if musicList and musicList:isVisible() then
					return
				end
			end,
			
			setVisible = function(self, visible)
				self.visible = visible
			end,
			
			showMusicList = function(self)
				if not musicList then
					musicList = require("tools/constructionSet/music/musicList"):create {
						x = self.fieldX,
						y = self.fieldY + self.fieldHeight,
						width = self.fieldWidth,
						height = 400,
						fontSize = 24,
						scrollSpeed = 1200,
						onMusicTrackSelected = function(item, index)
							selectedTrack = item or "None"
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
		}):init()
	end,
}
