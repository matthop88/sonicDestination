local STRING_UTIL = require("tools/lib/stringUtil")

return {
	getListOfMaps = function(self)
		local directoryItems = love.filesystem.getDirectoryItems("resources/zones/maps/")
    	local mapList = {}
    	for _, v in ipairs(directoryItems) do
        	if STRING_UTIL:endsWith(v, ".png") then
            	table.insert(mapList, string.sub(v, 1, -5))
            end
        end
        return mapList
    end,

    execute = function(self)
    	local mapList = self:getListOfMaps()
    	print(STRING_UTIL:caption("List of Map Files:"))
    	for _, f in ipairs(mapList) do
    		print(f)
    	end

    	print()

    	love.event.quit()
    end,
}
