local STRING_UTIL = require("tools/lib/stringUtil")

return ({
    scriptNames = {},

    init = function(self)
        local scriptFilenames = love.filesystem.getDirectoryItems("tools/badnikUniversity/scripts")
        for _, scriptFilename in ipairs(scriptFilenames) do
            if STRING_UTIL:endsWith(scriptFilename, ".lua") then
                print(scriptFilename)
                table.insert(self.scriptNames, string.sub(scriptFilename, 1, string.len(scriptFilename) - 4))
            end
        end

        return self
    end,
        
    get = function(self, scriptName)
        local script = dofile("tools/badnikUniversity/scripts/" .. scriptName .. ".lua")
        script.program = require("tools/lib/dataStructures/navigableList"):create(script.program)

        return script
    end,
        
}):init()
