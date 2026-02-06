local COLOR = require("tools/lib/colors")
local CHUNKS

-- A CHUNK is an object. It contains a chunkID, a reference to CHUNKS, and can draw itself into a space of optionally specified dimensions.

local CHUNK = {
    create = function(self, chunkID)
        return {
            chunkID    = chunkID,
            
            draw = function(self, graphics, x, y, w, h)
                if CHUNKS then
                    graphics:setColor(COLOR.PURE_WHITE)
                    local sX, sY = 1, 1
                    if w and h then sX, sY = w / 256, h / 256 end
                    CHUNKS:drawAt(graphics, x, y, self.chunkID, sX, sY) 
                end
            end,  
        }
    end,
}

-- A CHUNK_TEMPLATE is what solely resides in the container. It is capable of creating chunk objects, which can be placed on the map.

local CHUNK_TEMPLATE = {
    create = function(self, chunkID)
        local coreChunk = CHUNK:create(chunkID)

        return {
            hasFocus   = false,
            isSelected = false,
            chunkID    = chunkID,

            drawInContainer = function(self, graphics, x, y, w, h)
                x, y = x - (w / 2), y - (h / 2)
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
                return CHUNK:create(self.chunkID)
            end,
        }
    end,
}


        
return {
    create = function(self, stickyMouse)
        local chunkList = {}
        for id = 2, 17 do table.insert(chunkList, CHUNK_TEMPLATE:create(id)) end

        local palette   = require("tools/constructionSet/palette"):create { objects = chunkList, STICKY_MOUSE = stickyMouse }
        
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

