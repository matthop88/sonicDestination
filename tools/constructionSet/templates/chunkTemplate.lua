local COLOR = require("tools/lib/colors")

-- A CHUNK is an object. It contains a chunkID, a reference to CHUNKS, and can draw itself into a space of optionally specified dimensions.

local CHUNK = require("tools/constructionSet/chunk")

-- A CHUNK_TEMPLATE is what solely resides in the container. It is capable of creating chunk objects, which can be placed on the map.

return {
    create = function(self, chunkID, CHUNKS, SOLIDS, containerWidth, containerHeight)
        local coreChunk = CHUNK:create(chunkID, CHUNKS, SOLIDS, containerWidth, containerHeight)

        return {
            hasFocus   = false,
            isSelected = false,
            chunkID    = chunkID,

            drawInContainer = function(self, graphics, x, y, w, h)
                x, y = x - (w / 2), y - (h / 2)
                graphics:setColor(COLOR.PURE_WHITE)
                coreChunk:draw(graphics, x, y, w, h)

                if self.hasFocus and not self.isSelected then
                    graphics:setColor(1, 1, 0, 0.5)
                    graphics:rectangle("fill", x, y, w, h)
                end
            end,  

            gainFocus = function(self) self.hasFocus = true    end,
            loseFocus = function(self) self.hasFocus = false   end, 

            select    = function(self) self.isSelected = true  end,
            deselect  = function(self) self.isSelected = false end,

            newObject = function(self)
                return CHUNK:create(self.chunkID, CHUNKS, SOLIDS)
            end,
        }
    end,
}
