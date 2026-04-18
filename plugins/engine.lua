local engine = ({
    oldDraw          = function()       end,
    oldUpdate        = function(dt)     end,
    oldKeypressed    = function(key)    end,
    oldKeyreleased   = function(key)    end,
    oldMousepressed  = function(mx, my) end,
    oldMousereleased = function(mx, my) end,
    
    -- Performance stats tracking
    stats = {
        fps = 0,
        updateTime = 0,
        drawTime = 0,
        memory = 0,
        drawCalls = 0,
        updateHistory = {},
        drawHistory = {},
        maxHistory = 60,
        enabled = false,
        updateStartTime = 0,
        drawStartTime = 0,
        
        beginUpdate = function(self)
            self.updateStartTime = love.timer.getTime()
        end,
        
        endUpdate = function(self)
            self.updateTime = love.timer.getTime() - self.updateStartTime
            self:update()
        end,
        
        beginDraw = function(self)
            self.drawStartTime = love.timer.getTime()
        end,
        
        endDraw = function(self)
            self.drawTime = love.timer.getTime() - self.drawStartTime
        end,
        
        getAverage = function(self, history)
            if #history == 0 then return 0 end
            local sum = 0
            for _, v in ipairs(history) do
                sum = sum + v
            end
            return sum / #history
        end,
        
        getAvgUpdate = function(self)
            return self:getAverage(self.updateHistory) * 1000
        end,
        
        getAvgDraw = function(self)
            return self:getAverage(self.drawHistory) * 1000
        end,
        
        getTotalFrame = function(self)
            return self:getAvgUpdate() + self:getAvgDraw()
        end,
        
        update = function(self)
            self.fps = love.timer.getFPS()
            self.memory = collectgarbage("count")
            local graphicsStats = love.graphics.getStats()
            self.drawCalls = graphicsStats.drawcalls
            
            table.insert(self.updateHistory, self.updateTime)
            table.insert(self.drawHistory, self.drawTime)
            if #self.updateHistory > self.maxHistory then
                table.remove(self.updateHistory, 1)
            end
            if #self.drawHistory > self.maxHistory then
                table.remove(self.drawHistory, 1)
            end
        end,
    },
    
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
        love.mousepressed     = function(mx, my, p) self:mousepressed(mx, my, p)  end
            
        self.oldMousereleased = love.mousereleased or self.oldMousereleased
        love.mousereleased    = function(mx, my) self:mousereleased(mx, my) end
        
        return self
    end,
            
    draw = function(self)
        self.stats:beginDraw()
        
        self.oldDraw()
        for _, plugin in ipairs(self) do
            if plugin.draw ~= nil then plugin:draw() end
        end
        
        self.stats:endDraw()
    end,

    update = function(self, dt)
        self.stats:beginUpdate()
        
        for _, plugin in ipairs(self) do
            if plugin.update ~= nil and plugin:update(dt) then return true end
        end
        self.oldUpdate(dt)
        
        self.stats:endUpdate()
    end,

    keypressed = function(self, key)
        if self:modalKeypressed(key) then return end
        for _, plugin in ipairs(self) do
            if plugin.prehandleKeypressed ~= nil then key = plugin:prehandleKeypressed(key)        end
            if plugin.handleKeypressed    ~= nil and plugin:handleKeypressed(key) then return true end
        end
        self.oldKeypressed(key)
    end,

    modalKeypressed = function(self, key)
        for _, plugin in ipairs(self) do
            if plugin.modalKeypressed ~= nil and plugin:modalKeypressed(key) then return true end
        end
        return false
    end,

    keyreleased = function(self, key)
        for _, plugin in ipairs(self) do
            if plugin.prehandleKeyreleased ~= nil then key = plugin:prehandleKeyreleased(key)        end
            if plugin.handleKeyreleased    ~= nil and plugin:handleKeyreleased(key) then return true end
        end
        self.oldKeyreleased(key)
    end,

    mousepressed = function(self, mx, my)
        if self:modalMousepressed(mx, my) then return end
        local params = {}

        for _, plugin in ipairs(self) do
            if plugin.prehandleMousepressed ~= nil then plugin:prehandleMousepressed(mx, my, params)               end
            if plugin.handleMousepressed    ~= nil and  plugin:handleMousepressed(mx, my, params) then return true end
        end
        self.oldMousepressed(mx, my, params)
    end,

    modalMousepressed = function(self, mx, my)
        for _, plugin in ipairs(self) do
            if plugin.modalMousepressed ~= nil and plugin:modalMousepressed(mx, my) then return true end
        end
        return false
    end,

    mousereleased = function(self, mx, my)
        if self:modalMousereleased(mx, my) then return end
        for _, plugin in ipairs(self) do
            if plugin.handleMousereleased ~= nil and plugin:handleMousereleased(mx, my) then return true end
        end
        self.oldMousereleased(mx, my)
    end,

    modalMousereleased = function(self, mx, my)
        for _, plugin in ipairs(self) do
            if plugin.modalMousereleased ~= nil and plugin:modalMousereleased(mx, my) then return true end
        end
        return false
    end,

    add = function(self, pluginPath, params)
        local plugin
        local status, err = pcall(function() plugin = require("plugins/modules/" .. pluginPath) end)
        if status == false then
            plugin = require("plugins/modules/" .. pluginPath .. "/" .. pluginPath)
        end
        self:addPlugin(plugin, params)
        return self
    end,
        
    addPlugin = function(self, plugin, params)
        plugin = self:initPlugin(plugin, params or { })
        table.insert(self, plugin)
        return self
    end,

    initPlugin = function(self, plugin, params)
        if plugin.init ~= nil then plugin = plugin:init(params) end
        if params.accessorFnName ~= nil then
            self:createGlobalAccessorFn(params.accessorFnName, plugin)
        end
        plugin.__ENGINE = self
        return plugin
    end,

    createGlobalAccessorFn = function(self, name, plugin)
        _G[name] = function() return plugin end
    end,
    
    getStats = function(self)
        return self.stats
    end,
    
})

-- Set up global accessor before init
_G.getEngineStats = function()
    return engine.stats
end

-- Initialize and return
return engine:init()
