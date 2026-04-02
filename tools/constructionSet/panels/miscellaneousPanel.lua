return {
    create = function(self)
        local buttonList = {}
        local WIDTH, HEIGHT = 256, 256

        table.insert(buttonList, require("tools/constructionSet/music/musicButton"):create {})

        local palette = require("tools/constructionSet/palette"):create { objects = buttonList, CONTAINER_WIDTH = WIDTH, CONTAINER_HEIGHT = HEIGHT }
        
        return {
            draw                = function(self, graphics)   palette:draw(graphics)             end,
            update              = function(self, dt, mx, my) palette:update(dt, mx, my)         end,
            handleMousepressed  = function(self, mx, my)     palette:handleMousepressed(mx, my) end,
            handleMousereleased = function(self, mx, my)     palette:handleMousereleased(mx, my) end,
            handleKeypressed    = function(self, key)                                           end,
        }
    end,
}
