local propertyChangeNotifier = {
    listeners = {},
    
    addListener = function(self, listener)
        table.insert(self.listeners, listener)
        return self
    end,

    notifyListeners = function(self)
        local gameProperties = dofile(relativePath("properties/game.lua"))

        for _, listener in ipairs(self.listeners) do
            listener:onPropertyChange(gameProperties)
        end
    end,
}
    
local lastModificationTimestamp = nil
local timer                     = 0
local CHECK_INTERVAL            = 100

return {

    update = function(self, dt)
        timer = timer - (60 * dt)
        if timer < 0 then
            timer = CHECK_INTERVAL
            print("Needs Refreshing: ", self:needsRefresh())
            
            if self:needsRefresh() then
                self:refresh()
            end
        end
    end,
    
    notifyOnChange = function(self, listener)
        propertyChangeNotifier:addListener(listener)
    end,
    
    needsRefresh = function(self)
        local fileInfo = love.filesystem.getInfo(relativePath("properties/game.lua"))
        if fileInfo then
            return lastModificationTimestamp ~= fileInfo.modtime
        end
    end,

    refresh = function(self)
        propertyChangeNotifier:notifyListeners()
        self:refreshTimestamp()
    end,

    refreshTimestamp = function(self)
        local fileInfo = love.filesystem.getInfo(relativePath("properties/game.lua"))
        if fileInfo then
            lastModificationTimestamp = fileInfo.modtime
        end
    end,
}
