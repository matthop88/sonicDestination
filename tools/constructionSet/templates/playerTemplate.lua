local COLOR = require("tools/lib/colors")

local PLAYER = require("tools/constructionSet/templates/player")

return {
    create = function(self, name, spritePath, containerWidth, containerHeight)
        local corePlayer    = PLAYER:create(name, spritePath, containerWidth, containerHeight)
        local workingPlayer = nil

        return {
            name       = name,
            spritePath = spritePath,
            hasFocus   = false,
            isSelected = false,
            
            drawInContainer = function(self, graphics, x, y, w, h)
                graphics:setColor(COLOR.PURE_WHITE)
                if self.isSelected or self.hasFocus then corePlayer:draw(graphics, x, y, w, h)
                else                                     corePlayer:drawThumbnail(graphics, x, y, w, h) end
            end,  

            updateInContainer = function(self, dt)
                if self.hasFocus or self.isSelected then
                    corePlayer:update(dt)
                end
            end,

            gainFocus = function(self) self.hasFocus = true    end,
            loseFocus = function(self) self.hasFocus = false   end, 

            select    = function(self) self.isSelected = true  end,
            deselect  = function(self) self.isSelected = false end,
   
            newObject = function(self) 
                local xFlip = 1
                if workingPlayer then xFlip = workingPlayer.xFlip end
                workingPlayer = PLAYER:create(self.name, self.spritePath, nil, nil, xFlip) 
                return workingPlayer
            end,
        }
    end,
}
