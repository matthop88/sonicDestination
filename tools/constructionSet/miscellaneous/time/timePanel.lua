local COLOR = require("tools/lib/colors")

local TIMES_AT_START = {
	{ label = "INFINITY",    value =   -1 },
	{ label = "30 Seconds",  value =   30 },
	{ label = "1  Minute",   value =   60 },
	{ label = "2  Minutes",  value =  120 },
	{ label = "3  Minutes",  value =  180 },
	{ label = "4  Minutes",  value =  240 },
	{ label = "5  Minutes",  value =  300 },
	{ label = "10 Minutes",  value =  600 },
	{ label = "15 Minutes",  value =  900 },
	{ label = "20 Minutes",  value = 1200 },
	{ label = "25 Minutes",  value = 1500 },
	{ label = "30 Minutes",  value = 1800 },
	{ label = "35 Minutes",  value = 2100 },
	{ label = "40 Minutes",  value = 2400 },
	{ label = "45 Minutes",  value = 2700 },
	{ label = "50 Minutes",  value = 3000 },
	{ label = "1  Hour",     value = 3600 },
}

local TIME_MONITOR_DURATIONS = {
	{ label = "1 Second",   value = 1, },
	{ label = "2 Seconds",  value = 2, },
	{ label = "3 Seconds",  value = 3, },
	{ label = "4 Seconds",  value = 4, },
	{ label = "5 Seconds",  value = 5, },
	{ label = "6 Seconds",  value = 6, },
	{ label = "7 Seconds",  value = 7, },
	{ label = "8 Seconds",  value = 8, },
	{ label = "10 Seconds", value = 10,},
	{ label = "12 Seconds", value = 12,},
	{ label = "15 Seconds", value = 15,},
	{ label = "18 Seconds", value = 18,},
	{ label = "20 Seconds", value = 20,},
	{ label = "25 Seconds", value = 25,},
	{ label = "30 Seconds", value = 30,},
	{ label = "40 Seconds", value = 40,},
	{ label = "50 Seconds", value = 50,},
	{ label = "60 Seconds", value = 60,},
}

local timesAtStartDropdown
local timeTextEditableField
local timeMonitorDurationsDropdown

local createLabel = function(params)
	return {
		x     = params.x,
		y     = params.y,
		w     = params.w,
		h     = params.h or 50,
		label = params.label or "",
		font  = love.graphics.newFont(params.fontSize or 20),
			
		draw = function(self)
			love.graphics.setColor(COLOR.PURE_WHITE)
			love.graphics.setFont(self.font)
			
			love.graphics.print(self.label, self.x + 10, self.y + 15)
		end,
	}
end
				
return {
	create = function(self, params)
		return ({
			title     = "Time Settings",
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

				self.timeAtStartLabel = createLabel { x = self.x + 20, y = self.y +  80, w = 150, h = 50, label = "Time at Start", }
				self.timeTextLabel    = createLabel { x = self.x + 20, y = self.y + 140, w = 150, h = 50, label = "Text", }
				self.timeMonDurLabel  = createLabel { x = self.x + 20, y = self.y + 200, w = 150, h = 50, label = "Monitor Duration", }
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
				
				local selectedIndex = 1
				for n, v in ipairs(TIMES_AT_START) do
					if v.value == timeProperties.timeAtStart then
						selectedIndex = n
					end
				end

				timesAtStartDropdown = require("tools/lib/components/dropDownField"):create {
					x = self.x + 200,
					y = self.y + 80,
					width = 300,
					height = 50,
					label = "",
					list = TIMES_AT_START,
					selectedIndex = selectedIndex,
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

				selectedIndex = 1
				for n, v in ipairs(TIME_MONITOR_DURATIONS) do
					if v.value == timeProperties.timeMonitorDurations then
						selectedIndex = n
					end
				end

				timeMonitorDurationsDropdown = require("tools/lib/components/dropDownField"):create {
					x = self.x + 200,
					y = self.y + 200,
					width = 300,
					height = 50,
					label = "",
					list = TIME_MONITOR_DURATIONS,
					selectedIndex = selectedIndex,
					comparisonFn = function(listItem, value)
						return listItem.value == value
					end,
					onChanged = function(item, index)
						timeProperties.timeMonitorDurations = item.value
					end,
				}
		
				return self
			end,
					
			draw = function(self)
				if not self.visible then return end
				
				self:drawPanelBackground()
				self:drawTitle()
				self.timeAtStartLabel:draw()
				self.timeTextLabel:draw()
				self.timeMonDurLabel:draw()
				timesAtStartDropdown:draw()
				timeTextEditableField:draw()
				timeMonitorDurationsDropdown:draw()
				self.okButton:draw()
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

			update = function(self, dt)
				if not self.visible then return end
				
				local mx, my = love.mouse.getPosition()
				timesAtStartDropdown:update(dt, mx, my)
				timeTextEditableField:update(dt, mx, my)
				self.okButton:update(mx, my)
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

