local SELECT   = "select"
local SPRITE   = "sprite"

return ({
    graphics         = require("tools/lib/graphics"):create(), 
    sprites          = require("tools/spriteSandbox/sprites"),
    grid             = require("tools/spriteSandbox/grid"),
    mode             = nil,

    init = function(self)
        self:setSelectMode()
        return self
    end,

    draw = function(self)
        love.graphics.setColor(0.1, 0.1, 0.1)
        love.graphics.rectangle("fill", 0, 0, 1200, 800)

        self:drawGrid()
        self:drawSprites()
        self:drawMode()
        self:drawSelectedSprite()
    end,

    drawGrid = function(self)
        self.grid:draw(self.graphics)
    end,
    
    drawSprites = function(self)
        self.sprites:draw(self.graphics)
    end,

    drawMode = function(self)
        if   self.mode == SPRITE then self.sprites:drawCurrentSprite(self.graphics)
        else                          self.sprites:drawMouseoverSprite(self.graphics) end
    end,

    drawSelectedSprite = function(self)
        self.sprites:drawSelectedSprite(self.graphics)
    end,
            
    update = function(self, dt)
        self.sprites:update(dt, self.graphics)
    end,

    handleKeypressed = function(self, key)
        if     key == "s"      then
            if self.mode ~= SPRITE then self:setSpriteMode()
            else                        self:setSelectMode() end
        elseif key == "escape" then     
            self:setSelectMode()
            self.sprites:deselectSprite()
        elseif key == "shiftleft" or key == "shiftup" or key == "shiftdown" or key == "shiftright" then
            self.sprites:shiftSelectedSprite(key)
        end
    end,

    handleMousepressed = function(self, mx, my)
        if self.mode == SPRITE then
            self.sprites:placeCurrentSprite(self.graphics)
            
            if not love.keyboard.isDown("lalt", "ralt") then self:setSelectMode() end
        else
            self.sprites:onSpriteHeld(self.graphics)
        end
    end,

    handleMousereleased = function(self, mx, my)
        self.sprites:onSpriteReleased()
    end,

    setSelectMode = function(self)
        self.mode = SELECT
        love.mouse.setVisible(true)
    end,

    setSpriteMode = function(self)
        self.mode = SPRITE
        love.mouse.setVisible(false)
    end,

    moveImage = function(self, deltaX, deltaY)
        self.graphics:moveImage(deltaX / self.graphics:getScale(), deltaY / self.graphics:getScale())
    end,

    screenToImageCoordinates = function(self, screenX, screenY)
        return self.graphics:screenToImageCoordinates(screenX, screenY)
    end,

    imageToScreenCoordinates = function(self, imageX, imageY)
        return self.graphics:imageToScreenCoordinates(imageX, imageY)
    end,

    adjustScaleGeometrically = function(self, deltaScale)
        self.graphics:adjustScaleGeometrically(deltaScale)
    end,

    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
        self.graphics:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
    end,

}):init()
