local lastModificationTime = nil

return {
    needsRefresh = function(self)
        local fileInfo = love.filesystem.getInfo(relativePath("properties/game.lua"))
        if fileInfo then
            if lastModificationTime ~= fileInfo.modtime then
                lastModificationTime = fileInfo.modtime
                return true
            else
                lastModificationTime = fileInfo.modtime
                return false
            end
        end
    end,
}
