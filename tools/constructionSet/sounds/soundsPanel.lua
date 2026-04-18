local SOUND_DATA = require("game/sound/soundData")

local COLOR = require("tools/lib/colors")
local verticalSliderPane = require("tools/lib/components/verticalSliderPane")
local horizontalSlider = require("tools/lib/components/horizontalSlider")
local ACTIONS = { "Braking", "Jumping", "Collect Odd Ring", "Collect Even Ring", "Giant Ring", "Vanish", "Sonic Hit", "Badnik Hit" }

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

		}

		local soundRecommendations = {
			Braking           = { "Sonic Braking", "Sneakers" },
			Jumping           = { "Sonic Jumping", "Sonic CD Jumping" },
			Collect_Odd_Ring  = { "Ring Collect L" },
			Collect_Even_Ring = { "Ring Collect R" },
			Giant_Ring        = { "Giant Ring" },
			Vanish            = { "Vanish" },
			Sonic_Hit         = { "Sonic Hit", "Ice Explode", "Klank Ouch!" },
			Badnik_Hit        = { "Badnik Death", "Smoosh", "Bowling Strike" },
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
					list = ACTIONS,
					selectedIndex = 1,
					onChanged = function(item, index)
						soundDropDowns:show(item)
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
				if visible == false then
					actionDropDown:hideList()
					soundDropDowns:hide()
				end
				soundDropDowns:show(actionDropDown:getSelectedValue())
			end,

			buildSoundDropDowns = function(self)
				for _, action in ipairs(ACTIONS) do
					if action ~= "None" then
						local recommendations = soundRecommendations[action:gsub(" ", "_")] or {}
						local soundDropDown = 
							require("tools/lib/components/dropDownField"):create {
								x = self.x + 400,
								y = self.y + 80,
								width = 360,
								height = 50,
								list = self:buildSoundItems(recommendations),
								visible = false,
								selectedIndex = 2,
								onChanged = function(item, index)
									if item.value ~= "None" then
										SOUND_MANAGER:play(item.value)
									end
								end,
							}
						soundDropDown.action = action
						table.insert(soundDropDowns, soundDropDown)
					end
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
