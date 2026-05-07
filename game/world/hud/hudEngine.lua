return {
	create = function(self)
		local TIME = {
	        fontName = "hud",
	        keys = {
	            "t", "i", "m", "e", " ", "9", ":", "5", "9",
	        },
	    } 

	    local SCORE = {
	    	fontName = "hud",
	    	keys = {
	    		"s", "c", "o", "r", "e", " ", " ", "1", "0", "0", "0", "0", 
	    	},
	    }

	    local RINGS = {
	    	fontName = "hud",
	    	keys = {
	    		"r", "I", "N", "g", "s", " ", " ", "5", "0",
	    	},
	    }
    
    	return ({
    		fontEngine = require(relativePath("fonts/fontEngine")):create(),
    
    		init = function(self)
    			self.timeHud  = self.fontEngine:newFontObject(TIME)
    			self.scoreHud = self.fontEngine:newFontObject(SCORE)
    			self.ringsHud = self.fontEngine:newFontObject(RINGS)

    			return self
    		end,

            draw = function(self, graphics)
            	local oldScale = graphics:getScale()
				graphics:setScale(3)
				local scoreX, scoreY = graphics:screenToImageCoordinates(48, 48)
				local timeX,  timeY  = graphics:screenToImageCoordinates(48, 96)
				local ringsX, ringsY = graphics:screenToImageCoordinates(48, 144)
				
				self.scoreHud:draw(graphics, scoreX, scoreY)
            	self.timeHud:draw( graphics, timeX,  timeY)
            	self.ringsHud:draw(graphics, ringsX, ringsY)

            	graphics:setScale(oldScale)
            end,
    	}):init()
	
	end,
}
