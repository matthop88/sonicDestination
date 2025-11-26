local GRAPHICS
local TERRAIN
local WORKSPACE

return {
    objects = requireRelative("util/dataStructures/linkedList"):create(),  
    
    init = function(self, params)
        GRAPHICS = params.GRAPHICS
        TERRAIN  = requireRelative("world/terrain/terrain", { GRAPHICS = GRAPHICS })
        WORKSPACE = requireRelative("world/workspace",      { GRAPHICS = GRAPHICS })
        
        local ringMap = requireRelative("resources/zones/maps/ringMap")
        for _, ring in ipairs(ringMap) do
            self.objects:add(requireRelative("world/gameObjects/object"):create("objects/ring", ring.x, ring.y, GRAPHICS))
        end
        return self
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
            self.objects:getNext():update(dt)
        end
    end,

    refresh     = function(self)       TERRAIN:refresh()                  end,
    getTileIDAt = function(self, x, y) return TERRAIN:getTileIDAt(x, y)   end,
    getSolidAt  = function(self, x, y) return TERRAIN:getSolidAt(x, y)    end,

    toggleShowSolids   = function(self) TERRAIN:toggleShowSolids()        end,
}
