return ({
    rotatingBorder  = nil,
    coordinateBox   = nil,
    sprites         = {},  
    currentSprite   = nil,
    selectedSprite  = nil,
    mouseoverSprite = nil,

    init = function(self)
        self:initCurrentSprite(0, 0)
        return self
    end,

    draw = function(self, GRAFX)
        for _, sprite in ipairs(self.sprites) do sprite:draw(GRAFX) end
    end,

    drawCurrentSprite = function(self, GRAFX)
        self.currentSprite:draw(GRAFX)
    end,

    drawMouseoverSprite = function(self, GRAFX)
        if self.mouseoverSprite then
            local sprite = self.mouseoverSprite
            if sprite == self.selectedSprite then self:drawMouseoverSelectedRect(GRAFX)
            else                                  self:drawMouseoverRect(GRAFX)     end
        end
    end,

    drawMouseoverSelectedRect = function(self, GRAFX)
        if love.mouse.isDown(1) then self:drawMousepressedRect(GRAFX) end
    end,

    drawMousepressedRect = function(self, GRAFX)
        local sprite = self.mouseoverSprite
        local x, y, w, h = sprite:getX(), sprite:getY(), sprite:getW(), sprite:getH()
        
        GRAFX:setColor(1, 1, 1, 0.8)
        GRAFX:rectangle("fill", x - (w / 2) - 2, y - (h / 2) - 2, w + 4, h + 4)
    end, 

    drawMouseoverRect = function(self, GRAFX)    
        local sprite = self.mouseoverSprite
        local x, y, w, h = sprite:getX(), sprite:getY(), sprite:getW(), sprite:getH()
        
        GRAFX:setColor(0, 1, 1, 0.7)
        GRAFX:setLineWidth(1)
        GRAFX:rectangle("line", x - (w / 2) - 1, y - (h / 2) - 1, w + 2, h + 2)
    end,

    drawSelectedSprite = function(self, GRAFX)
        if self.rotatingBorder then self.rotatingBorder:draw(GRAFX) end
        if self.coordinateBox  then self.coordinateBox:draw(GRAFX)  end
    end,

    update = function(self, dt, GRAFX)
        local px, py = GRAFX:screenToImageCoordinates(love.mouse.getPosition())
        
        self:updateSprites(dt)
        self:updateMouseoverSprite(dt, px, py)
        self:updateCurrentSprite(dt, px, py)
        self:updateSelectedSprite(dt)
    end,

    updateSprites = function(self, dt)
        for _, sprite in ipairs(self.sprites) do sprite:update(dt) end
    end,

    updateMouseoverSprite = function(self, dt, px, py)
        self.mouseoverSprite = nil
        for _, sprite in ipairs(self.sprites) do
            if sprite:isInside(px, py) then self.mouseoverSprite = sprite end
        end
    end,

    updateCurrentSprite = function(self, dt, px, py)
        if self.currentSprite then
            self.currentSprite.x, self.currentSprite.y = px, py
            self.currentSprite:update(dt)
        end
    end,

    updateSelectedSprite = function(self, dt)
        if self.rotatingBorder then
            self.rotatingBorder:update(dt) 
            self.rotatingBorder:updateCoordinates(self.selectedSprite.x, self.selectedSprite.y)
        end
        if self.coordinateBox  then 
            self.coordinateBox:updateCoordinates(self.selectedSprite.x, self.selectedSprite.y)
        end
    end,

    onSpriteSelected = function(self)
        if self.mouseoverSprite then 
            self.selectedSprite = self.mouseoverSprite   

            local sprite = self.selectedSprite
            local x, y, w, h = sprite:getX(), sprite:getY(), sprite:getW(), sprite:getH()
            self.rotatingBorder = require("tools/spriteSandbox/rotatingBorder"):create(x, y, w, h)
            self.coordinateBox  = require("tools/spriteSandbox/coordinateBox"):create(x, y)
        end
    end,

    initCurrentSprite = function(self, px, py)
        self.currentSprite = require("tools/spriteSandbox/sprite"):create("objects/ring", px, py)
    end,

    placeCurrentSprite = function(self, GRAFX)
        table.insert(self.sprites, self.currentSprite)
        
        local px, py = GRAFX:screenToImageCoordinates(love.mouse.getPosition())
        self:initCurrentSprite(px, py)
    end,

    shiftSelectedSprite = function(self, key)
        if self.selectedSprite then
            local sprite = self.selectedSprite
            if     key == "shiftleft"  then sprite.x = sprite.x - 1
            elseif key == "shiftright" then sprite.x = sprite.x + 1
            elseif key == "shiftup"    then sprite.y = sprite.y - 1
            elseif key == "shiftdown"  then sprite.y = sprite.y + 1 end
        end
    end,

}):init()
