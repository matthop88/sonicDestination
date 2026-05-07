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
    
    		init = function(self)
    			local time  = self.fontEngine:newFontObject(TIME)
    			local timeDigits = self.fontEngine:newFontObject(TIME_DIGITS)
    			self.timeHud = require(relativePath("fonts/fontGroup")):create()
    								:add(time, { 0.99, 0.99, 0.0 })
    								:add(timeDigits)
    								
    			self.scoreHud = self.fontEngine:newFontObject(SCORE)
    			self.ringsHud = self.fontEngine:newFontObject(RINGS)
    			self.lifeHud  = self.fontEngine:newFontObject(LIFE)
    			return self
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
    	}):init()
	
	end,
}
