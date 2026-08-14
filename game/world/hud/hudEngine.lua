return {
	create = function(self)
		local SCORE = {
	    	fontName = "hud",
	    	keys = {
	    		"s", "c", "o", "r", "e", " ", " ", "0", "0", "0", "0", "0", "0",
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
    			self.ringsHud = require(relativePath("world/hud/ringsHud")):create()
    		end,

            draw = function(self, graphics)
            	local oldScale = graphics:getScale()
				graphics:setScale(3)
				local scoreX, scoreY = graphics:screenToImageCoordinates(48, 48)
				local lifeX,  lifeY  = graphics:screenToImageCoordinates(48, 700)
				
				self.scoreHud:draw(graphics, scoreX, scoreY, DISABLED_COLOR)
            	self.timeHud:draw(graphics)
            	self.ringsHud:draw(graphics)
            	self.lifeHud:draw(graphics, lifeX, lifeY, DISABLED_COLOR)

            	graphics:setScale(oldScale)
            end,

            update = function(self, dt)
            	self.timeHud:update(dt)
            	self.ringsHud:update(dt)
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
