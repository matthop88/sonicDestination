local ITEM_TEMPLATE = require("tools/constructionSet/templates/itemTemplate")

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
            handleKeypressed   = function(self, key)                                           end,
        }
    end,
}

