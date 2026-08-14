return {
	create = function(self)
		local TIME = {
	        fontName = "hud",
	        keys = {
	            "t", "i", "m", "e", " ",
	        },
	    }

	    local TIME_DIGITS = {
	    	fontName = "hud",
	    	keys = {
	    		"5", "9", ":", "5", "9",
	    	}
	    }

	    return ({
			fontEngine = require(relativePath("fonts/fontEngine")):create(),

			TIME_X          = 48,
			TIME_Y          = 96,
			
			timer           = 3600,
			timeMinutesTens = 5,
			timeMinutes     = 9,
			timeSecondsTens = 5,
			timeSecondsOnes = 9,

			redColor        = false,
			
			init = function(self)
				self.DIGITS  = require(relativePath("world/hud/digits")):create("hud")
				
				self.time  = self.fontEngine:newFontObject(TIME)
				self.timeDigits = self.fontEngine:newFontObject(TIME_DIGITS)
				self.timeHudObj = require(relativePath("fonts/fontGroup")):create()
									:add(self.time, { 0.99, 0.99, 0.0 })
									:add(self.timeDigits)

				return self
			end,

			draw = function(self, graphics)
				local timeX, timeY = graphics:screenToImageCoordinates(self.TIME_X, self.TIME_Y)
				self.timeHudObj:draw(graphics, timeX, timeY)
			end,

			update = function(self, dt)
		    	local oldTimer = math.floor(self.timer)
		    	self.timer = self.timer - dt
		    	if self.timer < 30 then
		    		self.redColor = true
		    	end

		    	if self.redColor then
		    		if math.floor(self.timer * 4) % 2 == 0 then
		    			self.time:setColor({ 0.99, 0, 0 })
		    		else
		    			self.time:setColor({ 0.99, 0, 0, 0.5})
		    		end
		    	else
		    		self.time:setColor({ 0.99, 0.99, 0 })
		    	end

		    	if math.floor(self.timer) ~= oldTimer and math.floor(self.timer) >= 0 then
		    		self:updateDigits()
		    	end
		    end,

		    updateDigits = function(self)
		    	self.timeSecondsOnes = math.floor(self.timer) % 10
		    	self.timeSecondsTens = math.floor(self.timer / 10)  %  6
		    	self.timeMinutes     = math.floor(self.timer / 60)  % 10
		    	self.timeMinutesTens = math.floor(self.timer / 600) %  6
		    		
		    	if self.timeMinutesTens > 0 then
					self.DIGITS:replaceDigits(self.timeDigits, { self.timeMinutesTens, self.timeMinutes, ":", self.timeSecondsTens, self.timeSecondsOnes })
				else
					self.DIGITS:replaceDigits(self.timeDigits, { "NIL", self.timeMinutes, ":", self.timeSecondsTens, self.timeSecondsOnes })
				end
			end,

			getTimer = function(self)
				return self.timer
			end,

		    refreshFromTimeProps = function(self, timeProps, timeOverride)
		    	if timeProps.timeLabel then
		    		TIME = {
		    			fontName = "hud",
		    			keys = {},
					}

					for i = 1, #timeProps.timeLabel do
						local char = timeProps.timeLabel:sub(i, i)
						table.insert(TIME.keys, char)
					end
					table.insert(TIME.keys, " ")
				end

				if timeOverride then
					self.timer = timeOverride
				elseif timeProps.timeAtStart then
					self.timer = timeProps.timeAtStart
				end
				self:init()
				if self.timer >= 0 then self:updateDigits() end
		    end,

		}):init()
	end,
}
