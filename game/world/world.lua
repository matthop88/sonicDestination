local GRAPHICS
local TERRAIN
local WORKSPACE

return {
    objects = {},

    init = function(self, params)
        GRAPHICS = params.GRAPHICS
        TERRAIN  = requireRelative("world/terrain/terrain", { GRAPHICS = GRAPHICS })
        WORKSPACE = requireRelative("world/workspace",      { GRAPHICS = GRAPHICS })
        
        table.insert(self.objects, requireRelative("world/gameObjects/object"):create("objects/ring", 500, 500, GRAPHICS))
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
