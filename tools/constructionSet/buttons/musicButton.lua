local COLOR = require("tools/lib/colors")

return {
	create = function(self, params)
		return {
			label = params.label or "Music",
			hasFocus = false,
			isSelected = false,
			isPressed = false,
			musicList = nil,
			windowWidth = params.windowWidth or 1200,
			windowHeight = params.windowHeight or 800,
			
			drawInContainer = function(self, graphics, x, y, w, h)
				if self.isPressed then
					-- Draw filled rectangle for pressed state
					graphics:setColor(1, 1, 0)
					graphics:rectangle("fill", x - w/2, y - h/2, w, h)
					graphics:setColor(0, 0, 0)
				elseif self.isSelected then
					graphics:setColor(1, 1, 0)
				else
					graphics:setColor(COLOR.PURE_WHITE)
				end
				graphics:setFontSize(48)
				graphics:printf(self.label, x - w/2, y - 24, w, "center")
			end,
			
			updateInContainer = function(self, dt)
			end,
			
			gainFocus = function(self)
				self.hasFocus = true
			end,
			
			loseFocus = function(self)
				self.hasFocus = false
			end,
			
			select = function(self)
				self.isSelected = true
				self.isPressed = true
			end,
			
			deselect = function(self)
				self.isSelected = false
			end,
			
			handleMousereleased = function(self, mx, my)
				self.isPressed = false
				if self.isSelected then
					self:showMusicList()
				end
			end,
			
			showMusicList = function(self)
				if not self.musicList then
					self.musicList = require("tools/constructionSet/music/musicList"):create {
						x = (self.windowWidth - 400) / 2,
						y = (self.windowHeight - 400) / 2,
						width = 400,
						height = 400,
						fontSize = 28,
						scrollSpeed = 1200,
					}
					self.musicList:setVisible(false)
					
					if _G.getOverlay then
						getOverlay():add(self.musicList)
					end
				end
				
				self.musicList:setVisible(true)
			end,
			
			newObject = function(self)
				return nil
			end,
		}
	end,
}
