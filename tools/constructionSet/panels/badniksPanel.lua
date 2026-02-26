local BADNIK_TEMPLATE = require("tools/constructionSet/templates/badnikTemplate")
        
return {
    create = function(self, templateParams, stickyMouse)
        local badnikList = {}
        local WIDTH, HEIGHT = 96, 96
        for _, param in ipairs(templateParams) do
            table.insert(badnikList, BADNIK_TEMPLATE:create(param.name, param.spritePath, WIDTH, HEIGHT))
        end

        local palette   = require("tools/constructionSet/palette"):create { objects = badnikList, CONTAINER_WIDTH = WIDTH, CONTAINER_HEIGHT = HEIGHT, STICKY_MOUSE = stickyMouse }

        return {
            draw               = function(self, graphics)   palette:draw(graphics)             end,
            update             = function(self, dt, mx, my) palette:update(dt, mx, my)         end,
            handleMousepressed = function(self, mx, my)     palette:handleMousepressed(mx, my) end,
            handleKeypressed   = function(self, key)                                           end,
        }
    end,
}

