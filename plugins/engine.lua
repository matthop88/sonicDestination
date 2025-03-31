return ({
    oldDraw          = function()       end,
    oldUpdate        = function(dt)     end,
    oldKeypressed    = function(key)    end,
    oldKeyreleased   = function(key)    end,
    oldMousepressed  = function(mx, my) end,
    oldMousereleased = function(mx, my) end,

    init = function(self)
        
        self.oldDraw = love.draw or self.oldDraw
        love.draw          = function() self:draw()                      end

        self.oldUpdate = love.update or self.oldUpdate
        love.update        = function(dt) self:update(dt)                end

        self.oldKeypressed = love.keypressed or self.oldKeypressed
        love.keypressed    = function(key) self:keypressed(key)          end

        self.oldKeyreleased = love.keyreleased or self.oldKeyreleased
        love.keyreleased   = function(key) self:keyreleased(key)         end

        self.oldMousepressed = love.mousepressed or self.oldMousepressed
        love.mousepressed  = function(mx, my) self:mousepressed(mx, my)  end

        self.oldMousereleased = love.mousereleased or self.oldMousereleased
        love.mousereleased = function(mx, my) self:mousereleased(mx, my) end

        return self
    end,
            
    draw = function(self)
        for _, plugin in ipairs(self) do
            if plugin.draw ~= nil then
                plugin:draw()
            end
        end
    end,

    update = function(self, dt)
        for _, plugin in ipairs(self) do
            if plugin.update ~= nil then
                plugin:update(dt)
            end
        end
    end,

    keypressed = function(self, key)
        for _, plugin in ipairs(self) do
            if plugin.handleKeypressed ~= nil then
                plugin:handleKeypressed(key)
            end
        end
    end,

    keyreleased = function(self, key)
        for _, plugin in ipairs(self) do
            if plugin.handleKeyreleased ~= nil then
                plugin:handleKeyreleased(key)
            end
        end
    end,

    mousepressed = function(self, mx, my)
        for _, plugin in ipairs(self) do
            if plugin.handleMousepressed ~= nil then
                if plugin:handleMousepressed(mx, my) then
                    return true
                end
            end
        end
    end,

    mousereleased = function(self, mx, my)
        for _, plugin in ipairs(self) do
            if plugin.handleMousereleased ~= nil then
                plugin:handleMousereleased(mx, my)
            end
        end
    end,

    add = function(self, pluginPath, params)
        local plugin = require("plugins/modules/" .. pluginPath)
        self:addPlugin(plugin, params or { })
        return self
    end,
        
    addPlugin = function(self, plugin, params)
        self:initPlugin(plugin, params)
        table.insert(self, plugin)
    end,

    initPlugin = function(self, plugin, params)
        if plugin.init ~= nil then plugin:init(params) end
        if params.accessorFnName ~= nil then
            self:createGlobalAccessorFn(params.accessorFnName, plugin)
        end
    end,

    createGlobalAccessorFn = function(self, name, plugin)
        _G[name] = function()
            return plugin
        end
    end,
    
}):init()
