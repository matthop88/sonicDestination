local CHUNK_TEMPLATE = require("tools/constructionSet/templates/chunkTemplate")
        
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

            initChunkInfo = function(self, chunksName)
                local CHUNKS_PATH             = "game/resources/zones/chunks/" .. chunksName .. ".lua"
                local CHUNKS_IMG, CHUNKS_DATA = requireRelative("world/terrain/chunkImageBuilder"):create(CHUNKS_PATH)
                
                self.CHUNKS:set(requireRelative("world/terrain/chunksBuilder"):create(CHUNKS_IMG, chunksName))
                self.SOLIDS:set(requireRelative("world/terrain/solidsBuilder"):create(CHUNKS_DATA))
            end,

            draw               = function(self, graphics)   palette:draw(graphics)               end,
            update             = function(self, dt, mx, my) palette:update(dt, mx, my)           end,
            handleMousepressed = function(self, mx, my)     palette:handleMousepressed(mx, my)   end,
            handleKeypressed   = function(self, key)        return palette:handleKeypressed(key) end,                                 
        }
    end,
}
