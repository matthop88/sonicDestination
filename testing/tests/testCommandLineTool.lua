return {

    commandLineTools = require("commandLineTools"),
    
    getName = function(self)
        return "Command Line Tool Tests"
    end,
    
    beforeAll = function(self)
        -- Do nothing
    end,

    before = function(self)
        -- Do nothing
    end,

    testNoArguments = function(self)
        local name = "No command-line arguments                            => { }"

        local params = self.commandLineTools:getParams({ })

        local keyCount = 0
        for k, v in pairs(params) do
            keyCount = keyCount + 1
        end

        return TESTING:assertTrue(name, keyCount == 0)
    end,

}
