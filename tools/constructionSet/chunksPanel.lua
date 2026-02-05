local COLOR     = require("tools/lib/colors")

local CONTAINER = require("tools/constructionSet/container")

local CHUNKS

-- A CHUNK is an object. It contains a chunkID, a reference to CHUNKS, and can draw itself into a space of optionally specified dimensions.

local CHUNK = {
    create = function(self, chunkID)
        return {
            chunkID = chunkID,

            draw = function(self, graphics, x, y, w, h)
                w = w or 256
                h = h or 256

                if CHUNKS then 
                    graphics:setColor(COLOR.PURE_WHITE)
                    CHUNKS:drawAt(graphics, x, y, self.chunkID, w / 256, h / 256) 
                end
            end,     
        }
    end,
}
        

return {
    create = function(self)
        
        local containers = {}

        local chunkID = 2
        for y = 16, 290, 143 do
            for x = 31, 1080, 143 do
                table.insert(containers, CONTAINER:create(CHUNK:create(chunkID), x, y, 128, 128))
                chunkID = chunkID + 1
            end
        end

        return {
            initChunkInfo = function(self)
                local CHUNKS_PATH   = "game/resources/zones/chunks/ghzChunks.lua"
                local CHUNKS_IMG, _ = requireRelative("world/terrain/chunkImageBuilder"):create(CHUNKS_PATH)
                CHUNKS              = requireRelative("world/terrain/chunksBuilder"):create(CHUNKS_IMG)
            end,

            draw = function(self, graphics)
                graphics:clear(COLOR.DARK_GREY)
                for _, c in ipairs(containers) do
                    c:draw(graphics)
                end
            end,

            update = function(self, dt, mx, my)
                for _, c in ipairs(containers) do
                    if c:isInside(mx, my) then c:gainFocus()
                    else                       c:loseFocus() end
                end
            end,

            handleMousepressed = function(self, mx, my)
                for _, c in ipairs(containers) do
                    if c:isInside(mx, my) then c:select()
                    else                       c:unselect() end
                end
            end,
        }
    end,
}

-- Also we need a generic palette.
-- We add objects to the palette. The palette ensconces them in containers.
-- When an element is selected, a callback (which can be registered) is notified, and it is passed the object.
-- This will be used for the mouse.

