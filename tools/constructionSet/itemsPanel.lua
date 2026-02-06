local COLOR = require("tools/lib/colors")
local ITEMS

-- An ITEM is an object. It contains a sprite, and can draw itself into a space of optionally specified dimensions.

local ITEM = {
    create = function(self, name, spritePath)
        return {
            name   = name,
            sprite = require("tools/lib/sprites/sprite"):create(spritePath, 0, 0),
            
            draw = function(self, graphics, x, y, w, h)
                local scale = 1
                local offX, offY = 0, 0
                if w and h then 
                    scale = 8 / math.sqrt(math.max(self.sprite:getW(), self.sprite:getH()))
                    offX = w / 2
                    offY = h / 2
                end
                
                graphics:setColor(COLOR.PURE_WHITE)
                self.sprite:drawThumbnail(graphics, x + offX, y + offY, scale, scale)
                
            end,     
        }
    end,
}
        
return {
    create = function(self)
        local itemList = {}
        table.insert(itemList, ITEM:create("ring", "objects/ring"))
        table.insert(itemList, ITEM:create("giantRing", "objects/giantRing"))

        local palette   = require("tools/constructionSet/palette"):create { objects = itemList, CONTAINER_WIDTH = 64, CONTAINER_HEIGHT = 64 }

        return {
            draw               = function(self, graphics)   palette:draw(graphics)             end,
            update             = function(self, dt, mx, my) palette:update(dt, mx, my)         end,
            handleMousepressed = function(self, mx, my)     palette:handleMousepressed(mx, my) end,
        
        }
    end,
}

