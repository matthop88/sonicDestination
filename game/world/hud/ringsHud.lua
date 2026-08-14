return {
	create = function(self)
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

	    return ({
			fontEngine = require(relativePath("fonts/fontEngine")):create(),

			RINGS_X         = 48,
			RINGS_Y         = 144,
			
			ringCount       = 0,
			timer           = 0,
			redColor        = false,
			
			init = function(self)
				self.DIGITS      = require(relativePath("world/hud/digits")):create("hud")
				
				self.rings       = self.fontEngine:newFontObject(RINGS)
    			self.ringDigits  = self.fontEngine:newFontObject(RING_DIGITS)
    			self.ringsHudObj = require(relativePath("fonts/fontGroup")):create()
    								:add(self.rings, { 0.99, 0.99, 0.0 })
    								:add(self.ringDigits)

				return self
			end,

			draw = function(self, graphics)
				local ringsX, ringsY = graphics:screenToImageCoordinates(self.RINGS_X, self.RINGS_Y)
				self.ringsHudObj:draw(graphics, ringsX, ringsY)
			end,

			update = function(self, dt)
		    	if self.ringCount == 0 then
		    		self:updateRingsFlashing(dt)
		    	end
		    end,

		    updateRingsFlashing = function(self, dt)
		    	self.timer = self.timer + (60 * dt)
		    	if self.timer > 8 then
		    		self.redColor = not self.redColor
		    		self.timer = self.timer - 8

		    		self:updateRingColor()
		    	end
		    end,

		    updateRingColor = function(self)
		    	if self.redColor then
		    		self.rings:setColor({ 0.99, 0, 0 })
		    	else
		    		self.rings:setColor({ 0.99, 0.99, 0 })
		    	end
		    end,

		    setRingCount = function(self, ringCount)
				self.ringCount = ringCount
				self:updateRingDigits()
			end,

			updateRingDigits = function(self)
				local ringCountOnes     = self.ringCount % 10
				local ringCountTens     = math.floor(self.ringCount / 10) % 10
				local ringCountHundreds = math.floor(self.ringCount / 100)
		    		
		    	if ringCountHundreds > 0 then
					self.DIGITS:replaceDigits(self.ringDigits, { ringCountHundreds, ringCountTens, ringCountOnes })
				else
					self.DIGITS:replaceDigits(self.ringDigits, { "NIL", ringCountTens, ringCountOnes })
				end

				self.rings:setColor({ 0.99, 0.99, 0 })
			end,

		    refreshFromRingProps = function(self, ringProps, ringOverride)
		    	-- Logic here to update
		    end,



		}):init()
	end,
}
