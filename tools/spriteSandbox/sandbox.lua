local SELECT   = "select"
local SPRITE   = "sprite"
local ROTATION = 0

return {
    graphics         = require("tools/lib/graphics"):create(),
    currentSprite    = require("tools/spriteSandbox/sprite"):create("objects/ring", 0, 0),

    spriteUnderMouse = nil,
    selectedSprite   = nil,
    
    sprites = {},
    mode    = SELECT,

    draw = function(self)
        love.graphics.setColor(0.1, 0.1, 0.1)
        love.graphics.rectangle("fill", 0, 0, 1200, 800)

        for _, sprite in ipairs(self.sprites) do
            sprite:draw(self.graphics)
        end

        self:drawMode()
    end,

    drawMode = function(self)
        if self.mode == SPRITE then
            love.mouse.setVisible(false)
            self.currentSprite:draw(self.graphics)
        else
            love.mouse.setVisible(true)
            self:drawSpriteMouseovers()
        end
        self:drawSelectedSprite()
    end,

    drawSelectedSprite = function(self)
        if self.selectedSprite then
            local sprite = self.selectedSprite
            local px, py = self:imageToScreenCoordinates(sprite:getX(), sprite:getY())
            love.graphics.push()
            love.graphics.translate(px, py)
            love.graphics.rotate(ROTATION)
            love.graphics.translate(-px, -py)
            local x, y, w, h = sprite:getX(), sprite:getY(), sprite:getW(), sprite:getH()
            self.graphics:setColor(1, 1, 1)
            self.graphics:setLineWidth(1)
            self.graphics:rectangle("line", x - (w / 2) - 2, y - (h / 2) - 2, w + 4, h + 4)
            love.graphics.pop()
        end
    end,

    drawSpriteMouseovers = function(self)
        if self.spriteUnderMouse then
            local sprite = self.spriteUnderMouse
            local x, y, w, h = sprite:getX(), sprite:getY(), sprite:getW(), sprite:getH()
            if sprite == self.selectedSprite then
                if love.mouse.isDown(1) then
                    self.graphics:setColor(1, 1, 1, 0.8)
                    self.graphics:rectangle("fill", x - (w / 2) - 2, y - (h / 2) - 2, w + 4, h + 4)
                end
            else
                self.graphics:setColor(0, 1, 1, 0.7)
                self.graphics:setLineWidth(1)
                self.graphics:rectangle("line", x - (w / 2) - 1, y - (h / 2) - 1, w + 2, h + 2)
            end
        end
    end,

    update = function(self, dt)
        local px, py = self:screenToImageCoordinates(love.mouse.getPosition())
        
        self.spriteUnderMouse = nil
        for _, sprite in ipairs(self.sprites) do
            sprite:update(dt)
            if sprite:isInside(px, py) then self.spriteUnderMouse = sprite end
        end
        self.currentSprite.x, self.currentSprite.y = px, py
        self.currentSprite:update(dt)

        ROTATION = ROTATION + (math.pi / 90)
    end,

    handleKeypressed = function(self, key)
        if key == "s" then
            if self.mode ~= SPRITE then self.mode = SPRITE
            else                   self.mode = SELECT end
        elseif key == "escape" then
            self.mode = SELECT
        end
    end,

    handleMousepressed = function(self, mx, my)
        if self.mode == SPRITE then
            self:placeSprite(mx, my)
            if not love.keyboard.isDown("lalt", "ralt") then
                self.mode = SELECT
            end
        elseif self.spriteUnderMouse then
            self.selectedSprite = self.spriteUnderMouse
        end
    end,

    handleMousereleased = function(self, mx, my)
        --self.selectedSprite = nil
    end,

    placeSprite = function(self, mx, my)
        table.insert(self.sprites, self.currentSprite)
        local sX, sY = self:screenToImageCoordinates(love.mouse.getPosition())
        self.currentSprite = require("tools/spriteSandbox/sprite"):create("objects/ring", sX, sY)
    end,

    moveImage = function(self, deltaX, deltaY)
        self.graphics:moveImage(deltaX, deltaY)
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

}
