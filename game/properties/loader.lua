local propertyChangeNotifier = {
    listeners = {},
    
    addListener = function(self, listener)
        table.insert(self.listeners, listener)
        return self
    end,

    notifyListeners = function(self)
        local gameProperties = doFile(relativePath("properties/game.lua"))

        for _, listener in ipairs(self.listeners) do
            listener:onPropertyChange(gameProperties)
        end
    end,
}
    
local lastModificationTimestamp = nil

return {
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
