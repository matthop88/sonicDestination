local NO_BUMP_ID = true

return {
    create = function(self, name, path)
        return {
            name = name,
            path = path,
            spritePreview = require("tools/lib/sprites/sprite"):create(path, 0, 0, NO_BUMP_ID),

            drawPreviewSprite = function(self, GRAFX, x, y)
                self.spritePreview:drawThumbnail(GRAFX, x, y, 1, 1)
            end,

            create = function(self, x, y)
                return {
                    name  = self.name,
                    x     = x,
                    y     = y,
                    sprite = require("tools/lib/sprites/sprite"):create(self.path, x, y),

                    getX  = function(self) return self.x     end,
                    getY  = function(self) return self.y     end,
                    setX  = function(self, x)     self.x = x end,
                    setY  = function(self, y)     self.y = y end,

                    draw  = function(self, GRAFX)
                        self.sprite:draw(GRAFX)
                    end,
                end
            end,
        }
    end,
}
