return ({
    oldDraw          = function()       end,
    oldUpdate        = function(dt)     end,
    oldKeypressed    = function(key)    end,
    oldKeyreleased   = function(key)    end,
    oldMousepressed  = function(mx, my) end,
    oldMousereleased = function(mx, my) end,

    init = function(self)
        
        self.oldDraw = love.draw or self.oldDraw
        love.draw          = function() 
            self.oldDraw()
            self:draw()                      
        end

        self.oldUpdate = love.update or self.oldUpdate
        love.update        = function(dt) 
            self.oldUpdate(dt)
            self:update(dt)                
        end

        self.oldKeypressed = love.keypressed or self.oldKeypressed
        love.keypressed    = function(key)
            if not self:keypressed(key) then
                self.oldKeypressed(key)
            end
        end

        self.oldKeyreleased = love.keyreleased or self.oldKeyreleased
        love.keyreleased   = function(key)
            if not self:keyreleased(key) then
                self.oldKeyreleased(key)
            end
        end

        self.oldMousepressed = love.mousepressed or self.oldMousepressed
        love.mousepressed  = function(mx, my)
            if not self:mousepressed(key) then
                self.oldMousepressed(mx, my)  
            end
        end
            
        self.oldMousereleased = love.mousereleased or self.oldMousereleased
        love.mousereleased = function(mx, my)
            if not self:mousereleased(mx, my) then
                self.oldMousereleased(mx, my)
            end
        end

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
                if plugin:handleKeypressed(key) then
                    return true
                end
            end
        end
    end,

    keyreleased = function(self, key)
        for _, plugin in ipairs(self) do
            if plugin.handleKeyreleased ~= nil then
                if plugin:handleKeyreleased(key) then
                    return true
                end
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
                if plugin:handleMousereleased(mx, my) then
                    return true
                end
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
