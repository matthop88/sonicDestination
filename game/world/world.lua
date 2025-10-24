local GRAPHICS
local TERRAIN
local WORKSPACE

return {
    init = function(self, params)
        GRAPHICS = params.GRAPHICS
        TERRAIN  = requireRelative("world/terrain/terrain", { GRAPHICS = GRAPHICS })
        WORKSPACE = requireRelative("world/workspace",      { GRAPHICS = GRAPHICS })
        
        return self
    end,

    draw = function(self)
        TERRAIN:draw()
        WORKSPACE:draw()
    end,

    refresh     = function(self)       TERRAIN:refresh()                end,
    getTileIDAt = function(self, x, y) return TERRAIN:getTileIDAt(x, y) end,
    getSolidAt  = function(self, x, y) return TERRAIN:getSolidAt(x, y)  end,

    toggleShowSolids = function(self) TERRAIN:toggleShowSolids() end,
}
