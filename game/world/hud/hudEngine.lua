return {
	create = function(self)
		local SCORE = {
	    	fontName = "hud",
	    	keys = {
	    		"s", "c", "o", "r", "e", " ", " ", "0", "0", "0", "0", "0", "0",
	    	},
	    }

	    local RINGS = {
	    	fontName = "hud",
	    	keys = {
	    		"r", "I", "N", "g", "s", " ",
	    	},
	    }

	    local RING_DIGITS = {
	    	fontName = "hud",
	    	keys = {
	    		" ", "0", "0",
	    	}
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
    			self:initTimeHud()
    			self:initRingsHud()
    			self.scoreHud = self.fontEngine:newFontObject(SCORE)
    			self.lifeHud  = self.fontEngine:newFontObject(LIFE)

    			self.DIGITS  = require(relativePath("world/hud/digits")):create("hud")
    			return self
    		end,

    		initTimeHud = function(self)
    			self.timeHud = require(relativePath("world/hud/timeHud")):create()				
    		end,

    		initRingsHud = function(self)
    			self.rings      = self.fontEngine:newFontObject(RINGS)
    			self.ringDigits = self.fontEngine:newFontObject(RING_DIGITS)
    			self.ringsHud   = require(relativePath("fonts/fontGroup")):create()
    								:add(self.rings, { 0.99, 0.99, 0.0 })
    								:add(self.ringDigits)
    		end,

            draw = function(self, graphics)
            	local oldScale = graphics:getScale()
				graphics:setScale(3)
				local scoreX, scoreY = graphics:screenToImageCoordinates(48, 48)
				local ringsX, ringsY = graphics:screenToImageCoordinates(48, 144)
				local lifeX,  lifeY  = graphics:screenToImageCoordinates(48, 700)
				
				self.scoreHud:draw(graphics, scoreX, scoreY, DISABLED_COLOR)
            	self.timeHud:draw(graphics)
            	self.ringsHud:draw(graphics, ringsX, ringsY)
            	self.lifeHud:draw(graphics, lifeX, lifeY, DISABLED_COLOR)

            	graphics:setScale(oldScale)
            end,

            update = function(self, dt)
            	self.timeHud:update(dt)
            end,

            getTimer = function(self)
            	return self.timeHud:getTimer()
            end,

            refreshFromTimeProps = function(self, timeProps, timeOverride)
            	self.timeHud:refreshFromTimeProps(timeProps, timeOverride)
            end,
    	}):init()
	
	end,
}
