local loadDataFilesFromDirectory = function(directoryName)
	local files = {}

	local directoryItems = love.filesystem.getDirectoryItems(directoryName)
    
    for _, v in ipairs(directoryItems) do
        if string.sub(v, -3, -1) == "lua" then
            local filename = string.sub(v, 1, -5)
            files[filename] = require(directoryName .. "/" .. filename)
        end
    end

    return files
end

return {
	create = function(self)
		return ({
			init = function(self)
				self.fonts = loadDataFilesFromDirectory(relativePath("resources/fonts"))

				for k, v in pairs(self.fonts) do
					print("Loaded key = " .. k .. ", value = ", v)
				end

				return self
			end,

		}):init()
	end,
}
