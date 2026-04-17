local SOUND_DATA = require("game/sound/soundData")

local COLOR = require("tools/lib/colors")
local verticalSliderPane = require("tools/lib/components/verticalSliderPane")
local horizontalSlider = require("tools/lib/components/horizontalSlider")

return {
	create = function(self, params)
		local okButton       = nil
		local actionDropDown = nil
		local soundDropDowns = {
			draw = function(self) 
				for _, v in ipairs(self) do v:draw() end
			end,

			update = function(self, dt, mx, my)
				for _, v in ipairs(self) do v:update(dt, mx, my) end
			end,

			handleMousepressed = function(self, mx, my)
				for _, v in ipairs(self) do v:handleMousepressed(mx, my) end
			end,
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
					width = 360,
					height = 50,
					list = { "None", "Braking", "Jumping", "Collect Odd Ring", "Collect Even Ring", "Giant Ring", "Vanish", "Sonic Hit", "Badnik Hit" },
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
				
			end,
			
			containsPoint = function(self, mx, my)
				return mx >= self.x and mx <= self.x + self.width and
				       my >= self.y and my <= self.y + self.height
			end,
							
			handleMouseReleased = function(self, mx, my)
				-- Do nothing
			end,
				
			setVisible = function(self, visible)
				self.visible = visible
			end,

			buildSoundDropDowns = function(self)
				table.insert(soundDropDowns, 
					require("tools/lib/components/dropDownField"):create {
						x = self.x + 400,
						y = self.y + 80,
						width = 360,
						height = 50,
						list = self:buildSoundItems(),
					}
				)
			end,

			buildSoundItems = function(self)
				local items = {}
				
				for soundKey, soundInfo in pairs(SOUND_DATA) do
					if soundInfo.label then
						table.insert(items, { label = soundInfo.label, value = soundKey })
					end
				end
				table.sort(items, function(a, b) return a.label < b.label end)
				
				return items
			end,
		
		}):init()
	end,
}
