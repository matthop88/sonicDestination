local SPRITE_FACTORY = require("tools/spriteSandbox/spriteFactory")

return ({
    rotatingBorder  = nil,
    coordinateBox   = nil,
    sprites         = require("tools/lib/dataStructures/linkedList"):create(),  
    currentSprite   = nil,
    selectedSprite  = nil,
    heldSprite      = nil,
    mouseoverSprite = nil,
    visualizedList  = nil,
    
    init = function(self)
        self:initCurrentSprite(0, 0)
        self.visualizedList = require("tools/spriteSandbox/listVisualizer"):create(self.sprites)
        return self
    end,

    draw = function(self, GRAFX)
        self:drawNonPlayer(GRAFX)
        self:drawPlayer(GRAFX)
        self:drawForeground(GRAFX)
        self.visualizedList:draw()
    end,

    drawNonPlayer = function(self, GRAFX)
        self.sprites:head()
        while not self.sprites:isEnd() do 
            local sprite = self.sprites:getNext()
            if not sprite:isPlayer() and not sprite:isForeground() then sprite:draw(GRAFX) end
        end
    end,

    drawPlayer = function(self, GRAFX)
        self.sprites:head()
        while not self.sprites:isEnd() do 
            local sprite = self.sprites:getNext()
            if sprite:isPlayer() then sprite:draw(GRAFX) end
        end
    end,

    drawForeground = function(self, GRAFX)
        self.sprites:head()
        while not self.sprites:isEnd() do 
            local sprite = self.sprites:getNext()
            if sprite:isForeground() then sprite:draw(GRAFX) end
        end
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
        self:updateHeldSprite(dt, px, py)
        self:updateSelectedSprite(dt)
    end,

    updateSprites = function(self, dt)
        self.sprites:head()
        while not self.sprites:isEnd() do 
            local sprite = self.sprites:get()
            sprite:update(dt)
            if sprite.deleted then
                if self.selectedSprite  and self.selectedSprite.deleted  then self:deselectSprite()      end
                if self.mouseoverSprite and self.mouseoverSprite.deleted then self.mouseoverSprite = nil end
                if self.heldSprite      and self.heldSprite.deleted      then self.heldSprite      = nil end
                self.sprites:remove() 
            else                   
                self.sprites:next()   
            end
        end
    end,

    updateMouseoverSprite = function(self, dt, px, py)
        if self.mouseoverSprite then self.mouseoverSprite.mousedOver = false end
        self.mouseoverSprite = nil
        self.sprites:head()
        while not self.sprites:isEnd() do 
            local sprite = self.sprites:getNext()
            if sprite:isInside(px, py) or sprite.mousedOverInVisualizer then 
                self.mouseoverSprite = sprite 
                self.mouseoverSprite.mousedOver = true
            end
        end
    end,

    updateCurrentSprite = function(self, dt, px, py)
        if self.currentSprite and not self.selectedSprite then
            self.currentSprite.x, self.currentSprite.y = px, py
            self.currentSprite:update(dt)
        end
    end,

    updateHeldSprite = function(self, dt, px, py)
        if self.heldSprite then
            local sprite, dx, dy = self.heldSprite.sprite, self.heldSprite.dx, self.heldSprite.dy
            sprite.x = math.floor(px + dx)
            sprite.y = math.floor(py + dy)
        end
    end,

    updateSelectedSprite = function(self, dt)
        if self.selectedSprite then
            if self.rotatingBorder then
                self.rotatingBorder:update(dt) 
                self.rotatingBorder:updateCoordinates(self.selectedSprite.x, self.selectedSprite.y)
            end
            if self.coordinateBox  then
                self.coordinateBox:update(dt)
                self.coordinateBox:updateCoordinates(self.selectedSprite.x, self.selectedSprite.y)
            end
        end
    end,

    selectSprite = function(self, sprite)
        if self.selectedSprite then self.selectedSprite.selected = false end
        sprite.selected = true
        self.selectedSprite = sprite
        local sprite = self.selectedSprite
        local x, y, w, h = sprite:getX(), sprite:getY(), sprite:getW(), sprite:getH()
        self.rotatingBorder = require("tools/spriteSandbox/rotatingBorder"):create(x, y, w, h)
        self.coordinateBox  = require("tools/spriteSandbox/coordinateBox"):create(x, y)
    end,

    deselectSprite = function(self)
        if self.selectedSprite then self.selectedSprite.selected = false end
        self.selectedSprite = nil
        self.rotatingBorder = nil
        self.coordinateBox  = nil
    end,

    onSpriteHeld = function(self, GRAFX)
        if self.mouseoverSprite then 
            self:holdSprite(GRAFX)
            self:selectSprite(self.mouseoverSprite) 
        end
    end,

    holdSprite = function(self, GRAFX)
        local px, py = GRAFX:screenToImageCoordinates(love.mouse.getPosition())
        local sprite = self.mouseoverSprite
        self.heldSprite = { sprite = sprite, dx = sprite.x - px, dy = sprite.y - py }
    end,

    onSpriteReleased = function(self)
        self.heldSprite = nil
    end,

    initCurrentSprite = function(self, px, py)
        self.currentSprite = SPRITE_FACTORY:getFromCache(px, py)
    end,

    placeCurrentSprite = function(self, GRAFX)
        local newSprite = SPRITE_FACTORY:create(self.currentSprite:getX(), self.currentSprite:getY())
        if self.currentSprite.xScale < 0 then newSprite:flipX() end
        self.sprites:add(newSprite))
        
        local px, py = GRAFX:screenToImageCoordinates(love.mouse.getPosition())
        self:initCurrentSprite(math.floor(px), math.floor(py)
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

    deleteSelectedSprite = function(self)
        if self.selectedSprite then 
            self.selectedSprite.deleted = true 
            self:deselectSprite()
        end
    end,

    advanceSelectedSprite = function(self)
        if self.selectedSprite then
            self.selectedSprite:advanceAnimation()
            self.rotatingBorder:updateDimensions(self.selectedSprite:getW(), self.selectedSprite:getH())
        end
    end,

    regressSelectedSprite = function(self)
        if self.selectedSprite then
            self.selectedSprite:regressAnimation()
            self.rotatingBorder:updateDimensions(self.selectedSprite:getW(), self.selectedSprite:getH())
        end
    end,

    advanceCurrent = function(self, GRAFX)
        SPRITE_FACTORY:next()
        self:updateCurrent(GRAFX)
    end,

    regressCurrent = function(self, GRAFX)
        SPRITE_FACTORY:prev()
        self:updateCurrent(GRAFX)
    end,

    updateCurrent = function(self, GRAFX)
        local px, py = GRAFX:screenToImageCoordinates(love.mouse.getPosition())
        self:initCurrentSprite(math.floor(px), math.floor(py))
    end,

    toggleFreeze = function(self)
        if self.selectedSprite then self.selectedSprite:toggleFreeze() end
    end,

    flipSelectedSpriteX = function(self)
        if self.selectedSprite then self.selectedSprite:flipX() end
    end,

    flipCurrentSpriteX = function(self)
        if self.currentSprite then self.currentSprite:flipX() end
    end,

}):init()
