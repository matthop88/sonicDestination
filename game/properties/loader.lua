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
