local COLOR = require("tools/lib/colors")
local CHUNKS

-- A CHUNK is an object. It contains a chunkID, a reference to CHUNKS, and can draw itself into a space of optionally specified dimensions.

local CHUNK = {
    create = function(self, chunkID)
        return {
            chunkID    = chunkID,
            hasFocus   = false,
            isSelected = false,

            drawInContainer = function(self, graphics, x, y, w, h)
                if CHUNKS then 
                    graphics:setColor(COLOR.PURE_WHITE)
                    CHUNKS:drawAt(graphics, x - (w / 2), y - (h / 2), self.chunkID, w / 256, h / 256) 
                end

                if self.hasFocus and not self.isSelected then
                    graphics:setColor(1, 1, 0, 0.5)
                    graphics:rectangle("fill", x - (w / 2), y - (h / 2), w, h)
                end
            end,  

            draw = function(self, graphics, x, y)
                if CHUNKS then
                    graphics:setColor(COLOR.PURE_WHITE)
                    CHUNKS:drawAt(graphics, x, y, self.chunkID, 1, 1)
                end
            end,

            gainFocus = function(self) self.hasFocus = true    end,
            loseFocus = function(self) self.hasFocus = false   end, 

            select    = function(self) self.isSelected = true  end,
            unselect  = function(self) self.isSelected = false end,
        }
    end,
}
        
return {
    create = function(self)
        local chunkList = {}
        for id = 2, 17 do table.insert(chunkList, CHUNK:create(id)) end

        local palette   = require("tools/constructionSet/palette"):create { objects = chunkList }

        return {
            initChunkInfo = function(self)
                local CHUNKS_PATH   = "game/resources/zones/chunks/ghzChunks.lua"
                local CHUNKS_IMG, _ = requireRelative("world/terrain/chunkImageBuilder"):create(CHUNKS_PATH)
                CHUNKS              = requireRelative("world/terrain/chunksBuilder"):create(CHUNKS_IMG)
            end,

            draw               = function(self, graphics)   palette:draw(graphics)             end,
            update             = function(self, dt, mx, my) palette:update(dt, mx, my)         end,
            handleMousepressed = function(self, mx, my)     palette:handleMousepressed(mx, my) end,
        
        }
    end,
}

-- We add objects to the palette. The palette ensconces them in containers.
-- When an element is selected, a callback (which can be registered) is notified, and it is passed the object.
-- This will be used for the mouse.

