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
        local name = "No  command-line arguments                              => { }"

        local params = self.commandLineTools:getParams({ })

        local keyCount = 0
        for k, v in pairs(params) do
            keyCount = keyCount + 1
        end

        return TESTING:assertTrue(name, keyCount == 0)
    end,

    testTwoArgumentsWithShorthand = function(self)
        local name = [[Two command-line arguments w/shorthand (-i myFile)      => { "i" = "myFile" }]]

        local params = self.commandLineTools:getParams({ "-i", "myFile" })
        
        return TESTING:assertEquals(name, "myFile", params["i"])
    end,

    testTwoArgumentsFullLength = function(self)
        local name = [[Two command-line arguments full-length (--inMap myFile) => { "inMap" = "myFile" }]]

        local params = self.commandLineTools:getParams({ "--inMap", "myFile" })
        
        return TESTING:assertEquals(name, "myFile", params["inMap"])
    end,

    testOneArgument = function(self)
        local name = [[One command-line argument (--silentMode)                => { "silentMode" = true }]]

        local params = self.commandLineTools:getParams({ "--silentMode" })
        
        return TESTING:assertEquals(name, true, params["silentMode"])
    end,

}
