local COLOR = require("tools/lib/colors")
local ITEMS

-- An ITEM is an object. It contains a sprite, and can draw itself into a space of optionally specified dimensions.

local ITEM = {
    create = function(self, name, spritePath)
        return {
            name       = name,
            sprite     = require("tools/lib/sprites/sprite"):create(spritePath, 0, 0),
            
            draw = function(self, graphics, x, y, w, h)
                local scale = 1
                if w and h then scale = 8 / math.sqrt(math.max(self.sprite:getW(), self.sprite:getH())) end
                
                graphics:setColor(COLOR.PURE_WHITE)
                self.sprite:drawAt(graphics, x, y, scale, scale)
            end,

            drawThumbnail = function(self, graphics, x, y, w, h)
                local scale = 1
                if w and h then scale = 8 / math.sqrt(math.max(self.sprite:getW(), self.sprite:getH())) end
                
                graphics:setColor(COLOR.PURE_WHITE)
                self.sprite:drawThumbnail(graphics, x, y, scale, scale)
            end,  

            update = function(self, dt)
                self.sprite:update(dt)
            end,
        }
    end,
}

local ITEM_TEMPLATE = {
    create = function(self, name, spritePath)
        local coreItem = ITEM:create(name, spritePath)

        return {
            name       = name,
            spritePath = spritePath,
            hasFocus   = false,
            isSelected = false,
            
            drawInContainer = function(self, graphics, x, y, w, h)
                if self.isSelected or self.hasFocus then coreItem:draw(graphics, x, y, w, h)
                else                                     coreItem:drawThumbnail(graphics, x, y, w, h) end 
            end,  

            updateInContainer = function(self, dt)
                if self.hasFocus or self.isSelected then
                    coreItem:update(dt)
                end
            end,

            gainFocus = function(self) self.hasFocus = true    end,
            loseFocus = function(self) self.hasFocus = false   end, 

            select    = function(self) self.isSelected = true  end,
            unselect  = function(self) self.isSelected = false end,
      
            newObject = function(self) return ITEM:create(self.name, self.spritePath) end,
        }
    end,
}
        
return {
    create = function(self)
        local itemList = {}
        table.insert(itemList, ITEM_TEMPLATE:create("ring", "objects/ring"))
        table.insert(itemList, ITEM_TEMPLATE:create("giantRing", "objects/giantRing"))

        local palette   = require("tools/constructionSet/palette"):create { objects = itemList, CONTAINER_WIDTH = 64, CONTAINER_HEIGHT = 64 }

        return {
            draw               = function(self, graphics)   palette:draw(graphics)             end,
            update             = function(self, dt, mx, my) palette:update(dt, mx, my)         end,
            handleMousepressed = function(self, mx, my)     palette:handleMousepressed(mx, my) end,
        
        }
    end,
}

