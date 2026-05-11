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
	    		"9", ":", "5", "9",
	    	}
	    }

	    local SCORE = {
	    	fontName = "hud",
	    	keys = {
	    		"s", "c", "o", "r", "e", " ", " ", "0", "0", "0", "0", "0", "0",
	    	},
	    }

	    local RINGS = {
	    	fontName = "hud",
	    	keys = {
	    		"r", "I", "N", "g", "s", " ", " ", "0", "0",
	    	},
	    }

	    local LIFE = {
	    	fontName = "hudSmall",
	    	keys = {
	    		"$", "x", "0", "0",
	    	}
	    }

	    local DISABLED_COLOR = { 1, 1, 1, 0.5 }
    
    	return ({
    		fontEngine = require(relativePath("fonts/fontEngine")):create(),
    
    		timer           = 600,
			timeMinutes     = 9,
    		timeSecondsTens = 5,
    		timeSecondsOnes = 9,

    		redColor        = false,
    		
    		init = function(self)
    			self:initTimeHud()
    			self.scoreHud = self.fontEngine:newFontObject(SCORE)
    			self.ringsHud = self.fontEngine:newFontObject(RINGS)
    			self.lifeHud  = self.fontEngine:newFontObject(LIFE)

    			self.DIGITS  = require(relativePath("world/hud/digits")):create("hud")
    			return self
    		end,

    		initTimeHud = function(self)
    			self.time  = self.fontEngine:newFontObject(TIME)
    			self.timeDigits = self.fontEngine:newFontObject(TIME_DIGITS)
    			self.timeHud = require(relativePath("fonts/fontGroup")):create()
    								:add(self.time, { 0.99, 0.99, 0.0 })
    								:add(self.timeDigits)
    								
    		end,

            draw = function(self, graphics)
            	local oldScale = graphics:getScale()
				graphics:setScale(3)
				local scoreX, scoreY = graphics:screenToImageCoordinates(48, 48)
				local timeX,  timeY  = graphics:screenToImageCoordinates(48, 96)
				local ringsX, ringsY = graphics:screenToImageCoordinates(48, 144)
				local lifeX,  lifeY  = graphics:screenToImageCoordinates(48, 700)
				
				self.scoreHud:draw(graphics, scoreX, scoreY, DISABLED_COLOR)
            	self.timeHud:draw( graphics, timeX,  timeY)
            	self.ringsHud:draw(graphics, ringsX, ringsY, DISABLED_COLOR)
            	self.lifeHud:draw(graphics, lifeX, lifeY, DISABLED_COLOR)

            	graphics:setScale(oldScale)
            end,

            update = function(self, dt)
            	local oldTimer = math.floor(self.timer)
            	self.timer = self.timer - dt
            	if self.redColor then
            		self.time:setColor({ 0.99, 0, 0 })
            	else
            		self.time:setColor({ 0.99, 0.99, 0 })
            	end

            	if math.floor(self.timer) ~= oldTimer then
            		if self.timeMinutes > 0 then
	            		self.timeSecondsOnes = self.timeSecondsOnes - 1
	            		if self.timeSecondsOnes < 0 then
	            			self.timeSecondsOnes = 9
	            			self.timeSecondsTens = self.timeSecondsTens - 1
	            			self.redColor = not self.redColor
	            			if self.timeSecondsTens < 0 then
	            				self.timeSecondsTens = 5
	            				self.timeMinutes = self.timeMinutes - 1
	            			end
	            		end
	            		self.DIGITS:replaceDigits(self.timeDigits, { self.timeMinutes, ":", self.timeSecondsTens, self.timeSecondsOnes })
	            	end
            	end
            end,

            refreshFromTimeProps = function(self, timeProps)
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

    			self:initTimeHud()
            end,
    	}):init()
	
	end,
}
