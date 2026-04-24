local STRING_UTIL = require("tools/lib/stringUtil")

return ({
    scriptNames = {},

    init = function(self)
        local scriptFilenames = love.filesystem.getDirectoryItems(relativePath("world/badniks/scripts"))
        for _, scriptFilename in ipairs(scriptFilenames) do
            if STRING_UTIL:endsWith(scriptFilename, ".lua") then
                table.insert(self.scriptNames, string.sub(scriptFilename, 1, string.len(scriptFilename) - 4))
            end
        end

        return self
    end,
        
    get = function(self, scriptName)
        local script = dofile(relativePath("world/badniks/scripts/" .. scriptName .. ".lua"))
        local programs = { 
            current = "default", 
            getCurrent = function(self) return self[self.current] end,
            setCurrent = function(self, current) self.current = current end,
        }
        for progName, prog in pairs(script.programs) do
            programs[progName] = requireRelative("util/dataStructures/navigableList"):create(prog)
        end

        script.programs = programs
        return script.programs
    end,
        
}):init()
