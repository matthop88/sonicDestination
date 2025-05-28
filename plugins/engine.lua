return ({
    oldDraw          = function()       end,
    oldUpdate        = function(dt)     end,
    oldKeypressed    = function(key)    end,
    oldKeyreleased   = function(key)    end,
    oldMousepressed  = function(mx, my) end,
    oldMousereleased = function(mx, my) end,

    init = function(self)
        
        self.oldDraw          = love.draw or self.oldDraw
        love.draw             = function() self:draw()                      end

        self.oldUpdate        = love.update or self.oldUpdate
        love.update           = function(dt) self:update(dt)                end

        self.oldKeypressed    = love.keypressed or self.oldKeypressed
        love.keypressed       = function(key) self:keypressed(key)          end

        self.oldKeyreleased   = love.keyreleased or self.oldKeyreleased
        love.keyreleased      = function(key) self:keyreleased(key)         end

        self.oldMousepressed  = love.mousepressed or self.oldMousepressed
        love.mousepressed     = function(mx, my) self:mousepressed(mx, my)  end
            
        self.oldMousereleased = love.mousereleased or self.oldMousereleased
        love.mousereleased    = function(mx, my) self:mousereleased(mx, my) end
        
        return self
    end,
            
    draw = function(self)
        self.oldDraw()
        for _, plugin in ipairs(self) do
            if plugin.draw ~= nil then plugin:draw() end
        end
    end,

    update = function(self, dt)
        self.oldUpdate(dt)
        for _, plugin in ipairs(self) do
            if plugin.update ~= nil and plugin:update(dt) then return true end
        end
    end,

    keypressed = function(self, key)
        for _, plugin in ipairs(self) do
            if plugin.prehandleKeypressed ~= nil then key = plugin:prehandleKeypressed(key)        end
            if plugin.handleKeypressed    ~= nil and plugin:handleKeypressed(key) then return true end
        end
        self.oldKeypressed(key)
    end,

    keyreleased = function(self, key)
        for _, plugin in ipairs(self) do
            if plugin.prehandleKeyreleased ~= nil then key = plugin:prehandleKeyreleased(key)        end
            if plugin.handleKeyreleased    ~= nil and plugin:handleKeyreleased(key) then return true end
        end
        self.oldKeyreleased(key)
    end,

    mousepressed = function(self, mx, my)
        for _, plugin in ipairs(self) do
            if plugin.handleMousepressed ~= nil and plugin:handleMousepressed(mx, my) then return true end
        end
        self.oldMousepressed(mx, my)
    end,

    mousereleased = function(self, mx, my)
        for _, plugin in ipairs(self) do
            if plugin.handleMousereleased ~= nil and plugin:handleMousereleased(mx, my) then return true end
        end
        self.oldMousereleased(mx, my)
    end,

    add = function(self, pluginPath, params)
        local plugin = require("plugins/modules/" .. pluginPath)
        self:addPlugin(plugin, params)
        return self
    end,
        
    addPlugin = function(self, plugin, params)
        self:initPlugin(plugin, params or { })
        table.insert(self, plugin)
        return self
    end,

    initPlugin = function(self, plugin, params)
        if plugin.init ~= nil then plugin:init(params) end
        if params.accessorFnName ~= nil then
            self:createGlobalAccessorFn(params.accessorFnName, plugin)
        end
    end,

    createGlobalAccessorFn = function(self, name, plugin)
        _G[name] = function() return plugin end
    end,
    
}):init()
