local COLOR = require("tools/lib/colors")

local timesAtStartDropdown
local timeTextEditableField
local timeMonitorDurationsDropdown
				
return {
	create = function(self, params)
		return ({
			title     = params.title or "Untitled Panel",
			titleFont = love.graphics.newFont(24),
			visible   = false,
			
			x         = params.x or 300,
			y         = params.y or 250,
			w         = params.w or 830,
			h         = params.h or 400,
				
			init = function(self)
				if _G.getModals then
					getModals():add(self)
				end

				self.timeAtStartLabel = require("tools/lib/components/label"):create { x = self.x + 20, y = self.y +  80, w = 150, h = 50, label = "Time at Start", }
				self.timeTextLabel    = require("tools/lib/components/label"):create { x = self.x + 20, y = self.y + 140, w = 150, h = 50, label = "Text", }
				self.timeMonDurLabel  = require("tools/lib/components/label"):create { x = self.x + 20, y = self.y + 200, w = 150, h = 50, label = "Monitor Duration", }
				self.okButton         = require("tools/lib/components/okButton"):create {
					x = self.x + self.w - 120,
					y = self.y + self.h - 60,
					width = 100,
					height = 40,
				}

				local timeProperties = getProperties().time
				if not timeProperties then
					getProperties().time = {}
					timeProperties = {}
				end
				
				timesAtStartDropdown = require("tools/lib/components/dropDownField"):create {
					x = self.x + 200,
					y = self.y + 80,
					width = 300,
					height = 50,
					label = "",
					list = require("tools/constructionSet/miscellaneous/time/timesAtStart"),
					selectedValue = timeProperties.timeAtStart,
					comparisonFn = function(listItem, value)
						return listItem.value == value
					end,
					onChanged = function(item, index)
						timeProperties.timeAtStart = item.value
					end,
				}

				timeTextEditableField = require("tools/lib/components/editableTextField"):create {
					x = self.x + 200,
					y = self.y + 140,
					w = 300,
					height = 50,
					text = getProperties().time.timeLabel or "time",
					inputLayerFn = getInputLayer,
					validKeys = { "b", "c", "e", "g", "i", "m", "n", "o", "r", "s", "t", "u", },
					transformer = function(text) return string.upper(text) end,
				}

				timeMonitorDurationsDropdown = require("tools/lib/components/dropDownField"):create {
					x = self.x + 200,
					y = self.y + 200,
					width = 300,
					height = 50,
					label = "",
					list = require("tools/constructionSet/miscellaneous/time/timeMonitorDurations"),
					selectedValue = timeProperties.timeMonitorDurations,
					comparisonFn = function(listItem, value)
						return listItem.value == value
					end,
					onChanged = function(item, index)
						timeProperties.timeMonitorDurations = item.value
					end,
				}

				self.components = {
					self.timeAtStartLabel,
					self.timeTextLabel,
					self.timeMonDurLabel,
					timesAtStartDropdown,
					timeTextEditableField,
					timeMonitorDurationsDropdown,
				}

				return self
			end,
					
			draw = function(self)
				if not self.visible then return end
				
				self:drawPanelBackground()
				self:drawTitle()
				self:drawComponents()
			end,
			
			drawPanelBackground = function(self)
				love.graphics.setColor(COLOR.DARK_GREY)
				love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
				love.graphics.setColor(COLOR.PURE_WHITE)
				love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
			end,
			
			drawTitle = function(self)
				love.graphics.setColor(COLOR.PURE_WHITE)
				love.graphics.setFont(self.titleFont)
				love.graphics.printf(self.title, self.x, self.y + 20, self.w, "center")
			end,

			drawComponents = function(self)
				for _, component in ipairs(self.components) do
					component:draw()
				end
				self.okButton:draw()
			end,

			update = function(self, dt)
				if not self.visible then return end
				
				local mx, my = love.mouse.getPosition()
				self:updateComponents(dt, mx, my)
				
				self.okButton:update(mx, my)
			end,

			updateComponents = function(self, dt, mx, my)
				for _, component in ipairs(self.components) do
					if component.update then component:update(dt, mx, my) end
				end
			end,
								
			handleMousePressed = function(self, mx, my)
				if not self.visible then return false end
				
				if not timeMonitorDurationsDropdown:isListVisible() and timesAtStartDropdown:handleMousepressed(mx, my) then
					timeTextEditableField:setEditing(false)
					return true
				end

				if timeTextEditableField:handleMousepressed(mx, my) then
					return true
				end

				if self.okButton:containsPoint(mx, my) and not timesAtStartDropdown:isListVisible() and not timeMonitorDurationsDropdown:isListVisible() then
					self:setVisible(false)
					return true
				end

				if not timesAtStartDropdown:isListVisible() and timeMonitorDurationsDropdown:handleMousepressed(mx, my) then
					timeTextEditableField:setEditing(false)
					return true
				end

				if self:containsPoint(mx, my) or timesAtStartDropdown:listContainsPoint(mx, my) or timeMonitorDurationsDropdown:listContainsPoint(mx, my) then
					return not timesAtStartDropdown:isListVisible() and not timeMonitorDurationsDropdown:isListVisible()
				end

				return true
			end,

			keypressed = function(self, key)
				if not self.visible then return false end

				if timeTextEditableField:handleKeypressed(key) then
					local timeProperties = getProperties().time
					timeProperties.timeLabel = timeTextEditableField:getText()
					return true
				end
			end,
			
			setVisible = function(self, visible)
				self.visible = visible
			end,

			containsPoint = function(self, mx, my)
				return mx >= self.x and mx <= self.x + self.w and
				       my >= self.y and my <= self.y + self.h
			end,
		}):init()
	end,
}

