local COLOR = require("tools/lib/colors")

-- A CHUNK is an object. It contains a chunkID, a reference to CHUNKS, and can draw itself into a space of optionally specified dimensions.

local CHUNK = require("tools/constructionSet/chunk")

-- A CHUNK_TEMPLATE is what solely resides in the container. It is capable of creating chunk objects, which can be placed on the map.

local CHUNK_TEMPLATE = {
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
        
return {
    create = function(self, stickyMouse, ids)
        local CHUNKS = require("tools/lib/dataStructures/lazyVal"):create()
        local SOLIDS = require("tools/lib/dataStructures/lazyVal"):create()

        local chunkList = {}
        local WIDTH, HEIGHT = 256, 256
        for _, id in ipairs(ids) do table.insert(chunkList, CHUNK_TEMPLATE:create(id, CHUNKS, SOLIDS, WIDTH, HEIGHT)) end

        local palette   = require("tools/constructionSet/palette"):create { objects = chunkList, CONTAINER_WIDTH = WIDTH, CONTAINER_HEIGHT = HEIGHT, STICKY_MOUSE = stickyMouse }
        
        return {
            CHUNKS = CHUNKS,
            SOLIDS = SOLIDS,

            initChunkInfo = function(self, chunksPath)
                local CHUNKS_PATH             = chunksPath
                local CHUNKS_IMG, CHUNKS_DATA = requireRelative("world/terrain/chunkImageBuilder"):create(CHUNKS_PATH)
                
                self.CHUNKS:set(requireRelative("world/terrain/chunksBuilder"):create(CHUNKS_IMG))
                self.SOLIDS:set(requireRelative("world/terrain/solidsBuilder"):create(CHUNKS_DATA))
            end,

            draw               = function(self, graphics)   palette:draw(graphics)               end,
            update             = function(self, dt, mx, my) palette:update(dt, mx, my)           end,
            handleMousepressed = function(self, mx, my)     palette:handleMousepressed(mx, my)   end,
            handleKeypressed   = function(self, key)        return palette:handleKeypressed(key) end,                                 
        }
    end,
}
