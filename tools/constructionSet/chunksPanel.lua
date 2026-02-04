local COLOR = require("tools/lib/colors")

local CHUNKS
        
local CONTAINER = {
    create = function(self, chunkID, x, y, w, h)
        return {
            chunkID    = chunkID,
            x          = x,
            y          = y,
            w          = w,
            h          = h,
            hasFocus   = false,
            isSelected = false,
            

            draw = function(self, graphics)
                if CHUNKS then CHUNKS:drawAt(graphics, self.x, self.y, self.chunkID, 0.5, 0.5) end
                graphics:setColor(self:getOutlineColor())
                graphics:setLineWidth(self:getOutlineWidth())
                graphics:rectangle("line", self.x - 1, self.y - 1, self.w + 2, self.h + 2)
                graphics:setLineWidth(1)
            end,

            isInside = function(self, x, y)
                return x >= self.x and x <= self.x + self.w and y >= self.y and y <= self.y + self.h
            end,

            gainFocus = function(self) self.hasFocus = true  end,
            loseFocus = function(self) self.hasFocus = false end,

            getOutlineColor = function(self)
                if     self.isSelected then return COLOR.PURE_WHITE
                elseif self.hasFocus   then return COLOR.LIGHT_YELLOW
                else                        return COLOR.LIGHT_GREY end
            end,

            getOutlineWidth = function(self)
                if self.hasFocus or self.isSelected then return 3
                else                                     return 1 end
            end,

            select   = function(self) self.isSelected = true  end,
            unselect = function(self) self.isSelected = false end,
        }
    end,
}

return {
    create = function(self)
        
        local containers = {}

        local chunkID = 2
        for y = 16, 290, 143 do
            for x = 31, 1080, 143 do
                table.insert(containers, CONTAINER:create(chunkID, x, y, 128, 128))
                chunkID = chunkID + 1
            end
        end

        return {
            initChunkInfo = function(self)
                local CHUNKS_PATH             = "game/resources/zones/chunks/ghzChunks.lua"
                local CHUNKS_IMG, CHUNKS_DATA = requireRelative("world/terrain/chunkImageBuilder"):create(CHUNKS_PATH)
                CHUNKS                  = requireRelative("world/terrain/chunksBuilder"):create(CHUNKS_IMG)
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
