local propertyChangeNotifier = {
    listeners = {},
    
    addListener = function(self, listener)
        table.insert(self.listeners, listener)
        return self
    end,

    notifyListeners = function(self)
        local gameProperties = doFile(relativePath("properties/data/game.lua"))

        for _, listener in ipairs(self.listeners) do
            listener:onPropertyChange(gameProperties)
        end
    end,
}
    
local lastModificationTime = nil

return {
    needsRefresh = function(self)
        local fileInfo = love.filesystem.getInfo(relativePath("properties/game.lua"))
        if fileInfo then
            return lastModificationTime ~= fileInfo.modtime
        end
    end,

    refresh = function(self)
        local fileInfo = love.filesystem.getInfo(relativePath("properties/game.lua"))
        if fileInfo then
            lastModificationTime = fileInfo.modtime
        end
    end,
}
