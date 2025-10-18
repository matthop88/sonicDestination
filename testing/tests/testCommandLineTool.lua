return {

    commandLineTools = require("commandLineTools"):create("test", { test = "testing/resources/testCmdSchema1" }),

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

    testFiveArgumentsMixed = function(self)
        local name = [[Five argument (-i inFile --silentMode -o outFile)       => { "silentMode" = true, "i" = "inFile", "o" = "outFile" }]]
        local params = self.commandLineTools:getParams({ "-i", "inFile", "--silentMode", "-o", "outFile" })
        
        return TESTING:assertTrue(name, params["silentMode"] == true
                                    and params["i"]          == "inFile"
                                    and params["o"]          == "outFile")
    end,

    testShortcutExpansion = function(self)
        local name = [[Five argument (-e 1 -w -z 9) yields "ekiEkiFoo", "woogieWoogieWoogie", "zizzerZazzerZuzz" ]]

        local eCmd = self.commandLineTools:expandShortcut("e")
        local wCmd = self.commandLineTools:expandShortcut("w")
        local zCmd = self.commandLineTools:expandShortcut("z")

        return TESTING:assertEquals(name, "ekiEkiFoo woogieWoogieWoogie zizzerZazzerZuzz", eCmd .. " " .. wCmd .. " " .. zCmd)
    end,

    testMixedArgumentNames = function(self)
        local name = [[Five argument (-e 1 --woogieWoogieWoogie -z 7)       => { "ekiEkiFoo" = "1", "woogiWoogieWoogie" = true, "zizzerZazzerZuzz" = "7" }]]
        
        local params = self.commandLineTools:getParams({ "-e", "1", "--woogieWoogieWoogie", "-z", "7" })

        return TESTING:assertTrue(name, params["ekiEkiFoo"]          == "1"
                                    and params["woogieWoogieWoogie"] == true
                                    and params["zizzerZazzerZuzz"]   == "7")
    end,

    testFindMissingParams = function(self)
        local name = [[Three argument (-e 1 --woogieWoogieWoogie)           => "Missing zizzerZazzerZuzz parameter"]]
        
        local params = self.commandLineTools:getParams({ "-e", "1", "--woogieWoogieWoogie" })

        local missingParams = self.commandLineTools:findMissingParams(params)

        return TESTING:assertEquals(name, "zizzerZazzerZuzz", missingParams[1])
    end,

    testHelp = function(self)
        local name = "Autogeneration of help for testCmdSchema1"

        local expectedHelpString = 
[[


Accepted commands include:
  --help,                      -h  Show this help.
  --ekiEkiFoo,                 -e  self-explanatory. There will be a quiz tomorrow.
  --woogieWoogieWoogie,        -w  are you frightened yet?
  --zizzerZazzerZuzz,          -z  as you can plainly see!
]]
        local actualHelpString = self.commandLineTools:generateHelp()

        return TESTING:assertEquals(name, expectedHelpString, actualHelpString)
    end,
        
}
