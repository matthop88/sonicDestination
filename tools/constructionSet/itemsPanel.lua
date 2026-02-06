local COLOR = require("tools/lib/colors")
local ITEMS

-- An ITEM is an object. It contains a sprite, and can draw itself into a space of optionally specified dimensions.

local ITEM = {
    create = function(self, name, spritePath, containerWidth, containerHeight)
        return ({
            init = function(self, name, spritePath, containerWidth, containerHeight)
                self.name   = name
                self.sprite = require("tools/lib/sprites/sprite"):create(spritePath, 0, 0)
                self.scale  = 1
                if containerWidth and containerHeight then
                    self.scale = 8 / math.sqrt(math.max(self.sprite:getW(), self.sprite:getH()))
                end

                return self
            end,
            
            draw = function(self, graphics, x, y, w, h)
                graphics:setColor(COLOR.PURE_WHITE)
                self.sprite:drawAt(graphics, x, y, self.scale, self.scale)
            end,

            drawThumbnail = function(self, graphics, x, y, w, h)
                graphics:setColor(COLOR.PURE_WHITE)
                self.sprite:drawThumbnail(graphics, x, y, self.scale, self.scale)
            end,  

            update = function(self, dt)
                self.sprite:update(dt)
            end,
        }):init(name, spritePath, containerWidth, containerHeight)
    end,
}

local ITEM_TEMPLATE = {
    create = function(self, name, spritePath, containerWidth, containerHeight)
        local coreItem = ITEM:create(name, spritePath, containerWidth, containerHeight)

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
            deselect  = function(self) self.isSelected = false end,
      
            newObject = function(self) return ITEM:create(self.name, self.spritePath) end,
        }
    end,
}
        
return {
    create = function(self, stickyMouse)
        local itemList = {}
        local WIDTH, HEIGHT = 64, 64

        table.insert(itemList, ITEM_TEMPLATE:create("ring", "objects/ring", WIDTH, HEIGHT))
        table.insert(itemList, ITEM_TEMPLATE:create("giantRing", "objects/giantRing", WIDTH, HEIGHT))

        local palette   = require("tools/constructionSet/palette"):create { objects = itemList, CONTAINER_WIDTH = WIDTH, CONTAINER_HEIGHT = HEIGHT, STICKY_MOUSE = stickyMouse }
        
        return {
            draw               = function(self, graphics)   palette:draw(graphics)             end,
            update             = function(self, dt, mx, my) palette:update(dt, mx, my)         end,
            handleMousepressed = function(self, mx, my)     palette:handleMousepressed(mx, my) end,
        
        }
    end,
}

