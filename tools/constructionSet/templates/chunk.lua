return {
    create = function(self, chunkID, CHUNKS, SOLIDS, DATA, containerWidth, containerHeight)
        print("Creating chunk with chunkID: ", chunkID, " DATA: ", DATA)
        return ({
            CHUNKS = CHUNKS,
            SOLIDS = SOLIDS,
            DATA   = DATA, 

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
                if self.CHUNKS:isValid() then
                    graphics:setColor(1, 1, 1, graphics:getAlpha())
                    self:drawChunk(graphics, x, y, w, h, self.chunkID)
                    if self.DATA and self.DATA:get().altChunkMap then
                        local altIndex = 1
                        local altChunks = self.DATA:get().altChunkMap[self.chunkID] or {}
                        for _, c in ipairs(altChunks) do
                            graphics:setColor(self.CHUNKS:get().COLORS:get(altIndex))
                            self:drawChunk(graphics, x, y, w, h, c)
                            altIndex = altIndex + 1
                            if altIndex > #self.CHUNKS:get().COLORS then altIndex = 1 end
                        end
                    end
                end
            end,

            drawChunk = function(self, graphics, x, y, w, h, id)
                if self.isHeld then
                    self.CHUNKS:get():drawAt(graphics, x - (128 * self.xFlip), y - 128, id, self.scale * self.xFlip, self.scale)
                    if self.showSolids then 
                        if self.xFlip == 1 then self.SOLIDS:get():drawAt(graphics, x - 128, y - 128, id) 
                        else                    self.SOLIDS:get():xFlippedDrawAt(graphics, x - 128, y - 128, id) end
                    end
                    graphics:setColor(1, 1, 1, graphics:getAlpha())
                    graphics:setLineWidth(1)
                    graphics:rectangle("line", x - 128, y - 128, 256, 256)
                else
                    if self.xFlip == -1 then self.CHUNKS:get():drawAt(graphics, x + 256, y, id, self.scale * self.xFlip, self.scale)
                    else                     self.CHUNKS:get():drawAt(graphics, x, y, id, self.scale * self.xFlip, self.scale)  end
                end
            end,

            quantizeXY = function(self, x, y)
                return (math.floor(x / 256) * 256) + 128, (math.floor(y / 256) * 256) + 128
            end,

            hold         = function(self) self.isHeld = true                    end,
            release      = function(self) self.isHeld = false                   end,
            flipX        = function(self) self.xFlip  = 0 - self.xFlip          end,
            toggleSolids = function(self) self.showSolids = not self.showSolids end,

            place        = function(self, map, x, y)
                if map:placeChunk(self, math.floor(x / 256), math.floor(y / 256)) then
                    self:release()
                    return true
                end
            end, 

            toString     = function(self)
                local xFlipString = ""
                if self.xFlip < 0 then xFlipString = ", xFlip = true" end

                return "{ \"" .. self.CHUNKS:get():getChunksName() .. "\", " .. self.chunkID .. xFlipString .. "}"
            end,

        }):init(chunkID, containerWidth, containerHeight)
    end,
}
