local GRAPHICS
local TERRAIN
local WORKSPACE
local OBJECT_FACTORY = requireRelative("world/gameObjects/objectFactory")

return {
    collisionHandler = requireRelative("collision/collisionHandler"),

    objects = nil,

    fadeLayer = { 
        color    = { r = 1, g = 1, b = 1 }, 
        alpha    = 0,
        speed    = 1,
        velocity = 0,

        draw = function(self)
            GRAPHICS:setColor(self.color.r, self.color.g, self.color.b, self.alpha)
            GRAPHICS:rectangle("fill", GRAPHICS:calculateViewport())
        end,

        update = function(self, dt)
            self.alpha = self.alpha + (self.velocity * dt)
            if     self.alpha > 1 then self.alpha = 1
            elseif self.alpha < 0 then self.alpha = 0 end
        end,

        fadeOut = function(self) self.velocity =  self.speed end,
        fadeIn  = function(self) self.velocity = -self.speed end,
    },

    init = function(self, params)
        GRAPHICS = params.GRAPHICS
        TERRAIN  = requireRelative("world/terrain/terrain", { GRAPHICS = GRAPHICS })
        WORKSPACE = requireRelative("world/workspace",      { GRAPHICS = GRAPHICS })
        
        self:refreshRingMap()
        return self
    end,

    refreshRingMap = function(self)
        local ringMap = requireRelative("resources/zones/maps/ringMap")
        self.objects = dofile(relativePath("util/dataStructures/linkedList.lua")):create()
        for _, objectData in ipairs(ringMap) do
            self.objects:add(OBJECT_FACTORY:create(objectData, GRAPHICS))
        end
    end,

    reset = function(self)
        self:refreshRingMap()
        GLOBALS:getPlayer():initPosition()
        GRAPHICS:setX(0)
        GRAPHICS:setY(-384)
    end,

    draw = function(self)
        TERRAIN:draw()
        WORKSPACE:draw()
        self.objects:head()
        while not self.objects:isEnd() do
            local object = self.objects:getNext()
            if not object:isForeground() then object:draw() end
        end
    end,

    drawForeground = function(self)
        self.objects:head()
        while not self.objects:isEnd() do
            local object = self.objects:getNext()
            if object:isForeground() then object:draw(SHOW_HITBOXES) end
        end
        self.fadeLayer:draw()
    end,

    drawHitBoxes = function(self)
        self.objects:head()
        while not self.objects:isEnd() do
            self.objects:getNext():drawHitBox()
        end
    end,

    update = function(self, dt)
        self.objects:head()
        while not self.objects:isEnd() do
            local object = self.objects:get()
            object:update(dt)
            if object.deleted then self.objects:remove()
            else                   self.objects:next()   end
        end
        self.fadeLayer:update(dt)
    end,

    checkCollisions = function(self, otherObject)
        local otherHitBox = otherObject:getHitBox()
        self.objects:head()
        while not self.objects:isEnd() do
            local object = self.objects:getNext()
            local hitBox = object:getHitBox()
            if hitBox and hitBox:intersects(otherHitBox) and otherObject:isPlayer() then
                self.collisionHandler:handleCollisionWithPlayer(object, otherObject)
                return object
            end
        end
    end,

    refresh     = function(self)       TERRAIN:refresh()                  end,
    getTileIDAt = function(self, x, y) return TERRAIN:getTileIDAt(x, y)   end,
    getSolidAt  = function(self, x, y) return TERRAIN:getSolidAt(x, y)    end,

    toggleShowSolids   = function(self) TERRAIN:toggleShowSolids()        end,

    fadeOut     = function(self) self.fadeLayer:fadeOut()                 end,
    fadeIn      = function(self) self.fadeLayer:fadeIn()                  end,
}
