local NO_BUMP_ID = true

return {
    createTemplate = function(self, name, path)
        return {
            name  = name,
            path  = path,
            spritePreview = require("tools/lib/sprites/sprite"):create(path, 0, 0, NO_BUMP_ID),
            xFlip = false,
            
            drawPreviewSprite = function(self, GRAFX, x, y)
                GRAFX:setColor(1, 1, 1)
                self.spritePreview:drawThumbnail(GRAFX, x, y, 1, 1)
            end,

            flipX = function(self) 
                self.spritePreview:flipX() 
                self.xFlip = not self.xFlip
            end,

            create = function(self, x, y)
                local sprite = require("tools/lib/sprites/sprite"):create(self.path, x, y)
                if self.xFlip then sprite:flipX() end

                return {
                    name  = self.name,
                    x     = x,
                    y     = y,
                    sprite = sprite,

                    getX  = function(self) return self.x     end,
                    getY  = function(self) return self.y     end,
                    setX  = function(self, x)     self.x = x end,
                    setY  = function(self, y)     self.y = y end,

                    draw  = function(self, GRAFX)
                        self.sprite:draw(GRAFX)
                    end,
                }
            end,
        }
    end,
}
