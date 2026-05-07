return {
	create = function(self, fontName)
		local fontEngine = require(relativePath("fonts/fontEngine")):create()
		
		local ZERO  = { fontName = fontName, key = "0" }
		local ONE   = { fontName = fontName, key = "1" }
		local TWO   = { fontName = fontName, key = "2" }
		local THREE = { fontName = fontName, key = "3" }
		local FOUR  = { fontName = fontName, key = "4" }
		local FIVE  = { fontName = fontName, key = "5" }
		local SIX   = { fontName = fontName, key = "6" }
		local SEVEN = { fontName = fontName, key = "7" }
		local EIGHT = { fontName = fontName, key = "8" }
		local NINE  = { fontName = fontName, key = "9" }
		
		local DIGITS = {
			fontEngine:newGlyph(ZERO),
			fontEngine:newGlyph(ONE),
			fontEngine:newGlyph(TWO),
			fontEngine:newGlyph(THREE),
			fontEngine:newGlyph(FOUR),
			fontEngine:newGlyph(FIVE),
			fontEngine:newGlyph(SIX),
			fontEngine:newGlyph(SEVEN),
			fontEngine:newGlyph(EIGHT),
			fontEngine:newGlyph(NINE),
		}

		local COLON = fontEngine:newGlyph { fontName = fontName, key = ":" }
	    
		return {
    		replaceDigits = function(self, fontObject, glyphs)
    			for i = 1, #glyphs do
    				fontObject.glyphs:tail()
					fontObject.glyphs:remove()
				end

				fontObject.glyphs:head()

    			for _, g in ipairs(glyphs) do
    				if g == ":" then fontObject.glyphs:add(COLON)
    				else
    					fontObject.glyphs:add(DIGITS[g + 1])
    				end
    			end
    		end,
    	}
	
	end,
}
