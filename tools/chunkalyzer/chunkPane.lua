--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local GRAFX = require("tools/lib/graphics"):create()

return {
	draw = function(self)
        GRAFX:setColor(0, 0, 0)
        GRAFX:rectangle("fill", 0, 0, GRAFX:calculateViewport())
    end,

    update = function(self, dt)
        -- Do nothing
    end,

    handleKeypressed = function(self, key)
        -- Do nothing
    end,

    handleMousepressed = function(self, mx, my)
        -- Do nothing
    end,

}
