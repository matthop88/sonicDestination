return {
    init = function(self)
        self.oldDraw = love.draw

        love.draw = function()
            if self.oldDraw ~= nil then
                self.oldDraw()
            end
            self:draw()
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
                plugin:handleMousepressed(mx, my)
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

    add = function(self, pluginPath, param)
        local plugin = require("plugins/modules/" .. pluginPath)
        if plugin.init ~= nil then plugin:init(param) end
        table.insert(self, plugin)
        return self
    end,
}
