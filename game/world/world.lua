local GRAPHICS
local TERRAIN
local WORKSPACE

return {
    objects = {},

    init = function(self, params)
        GRAPHICS = params.GRAPHICS
        TERRAIN  = requireRelative("world/terrain/terrain", { GRAPHICS = GRAPHICS })
        WORKSPACE = requireRelative("world/workspace",      { GRAPHICS = GRAPHICS })
        
        local ringMap = requireRelative("resources/zones/maps/ringMap")
        for _, ring in ipairs(ringMap) do
            table.insert(self.objects, requireRelative("world/gameObjects/object"):create("objects/ring", ring.x, ring.y, GRAPHICS))
        end
        return self
    end,

    draw = function(self)
        TERRAIN:draw()
        WORKSPACE:draw()
        for _, obj in ipairs(self.objects) do
            obj:draw()
        end
    end,

    update = function(self, dt)
        for _, obj in ipairs(self.objects) do
            obj:update(dt)
        end
    end,

    refresh     = function(self)       TERRAIN:refresh()                end,
    getTileIDAt = function(self, x, y) return TERRAIN:getTileIDAt(x, y) end,
    getSolidAt  = function(self, x, y) return TERRAIN:getSolidAt(x, y)  end,

    toggleShowSolids = function(self) TERRAIN:toggleShowSolids() end,
}
