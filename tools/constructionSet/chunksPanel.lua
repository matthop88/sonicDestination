local COLOR = require("tools/lib/colors")
local CHUNKS

-- A CHUNK is an object. It contains a chunkID, a reference to CHUNKS, and can draw itself into a space of optionally specified dimensions.

local CHUNK = {
    create = function(self, chunkID, containerWidth, containerHeight)
        return ({
            isHeld = false,
            xFlip  = 1,

            init = function(self, chunkID, containerWidth, containerHeight)
                self.chunkID = chunkID
                self.scale   = 1
                if containerWidth and containerHeight then
                    self.scale = math.min(containerWidth / 256, containerHeight / 256)
                end

                return self
            end,

            draw = function(self, graphics, x, y, w, h)
                if CHUNKS then
                    if self.isHeld then
                        CHUNKS:drawAt(graphics, x - (128 * self.xFlip), y - 128, self.chunkID, self.scale * self.xFlip, self.scale)
                        graphics:setColor(0.5, 0.5, 0.5)
                        graphics:setLineWidth(3)
                        graphics:line(x - 32, y,      x + 32, y)
                        graphics:line(x,      y - 32, x,      y + 32)
                    else
                        CHUNKS:drawAt(graphics, x, y, self.chunkID, self.scale * self.xFlip, self.scale) 
                    end
                end
            end, 

            hold    = function(self) self.isHeld = true           end,
            release = function(self) self.isHeld = false          end,
            flipX   = function(self) self.xFlip  = 0 - self.xFlip end,
        }):init(chunkID, containerWidth, containerHeight)
    end,
}

-- A CHUNK_TEMPLATE is what solely resides in the container. It is capable of creating chunk objects, which can be placed on the map.

local CHUNK_TEMPLATE = {
    create = function(self, chunkID, containerWidth, containerHeight)
        local coreChunk = CHUNK:create(chunkID, containerWidth, containerHeight)

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
                return CHUNK:create(self.chunkID)
            end,
        }
    end,
}
        
return {
    create = function(self, stickyMouse)
        local chunkList = {}
        local WIDTH, HEIGHT = 128, 128
        local ids = { 10, 19, 17, 5, 9, }
        for _, id in ipairs(ids) do table.insert(chunkList, CHUNK_TEMPLATE:create(id, WIDTH, HEIGHT)) end

        local palette   = require("tools/constructionSet/palette"):create { objects = chunkList, CONTAINER_WIDTH = WIDTH, CONTAINER_HEIGHT = HEIGHT, STICKY_MOUSE = stickyMouse }
        
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
