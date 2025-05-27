local ASTERISKS     = "**********************************************************************************************************\n"

return {
    initTests = function(self, testsClass)
        self.testsClass = testsClass

        self.runnableTests = {}

        for testName, test in pairs(testsClass) do
            if testName:sub(1, 4) == "test" then
                table.insert(self.runnableTests, test)
            end
        end
    end,

    runAll = function(self)
        local testsSucceeded = 0

        print("\nRunning Tests\n-------------")

        if self.testsClass.beforeAll then
            self.testsClass:beforeAll()
        end
        
        for _, test in ipairs(self.runnableTests) do
            if self:runTest(test) then
                testsSucceeded = testsSucceeded + 1
            end
        end

        local testsFailed = #self.runnableTests - testsSucceeded

        print("\nTests succeeded: " .. testsSucceeded .. " out of " .. #self.runnableTests)
        if testsFailed > 0 then
            print("\n" .. testsFailed .. " tests FAILED.")
        end
        print("\n")
        
        love.event.quit()
    end,

    runTest = function(self, testFn)
        if self.testsClass.before then
            self.testsClass:before()
        end
        return testFn(self.testsClass)
    end,

    assertTrue = function(self, name, expression)
        if expression == true then
            print("PASSED => " .. name)
            return true
        else
            print("\n" .. ASTERISKS .. "FAILED => " .. name .. "\n" .. ASTERISKS)
            return false
        end
    end,

    assertEquals = function(self, name, expected, actual)
        if expected == actual then
            print("PASSED => " .. name)
            return true
        else
            print("\n" .. ASTERISKS .. "FAILED => " .. name)
            print("  Expected: ", expected)
            print("  Actual: ",   actual)
            print(ASTERISKS)
            return false
        end
    end,
}

love.window.setTitle("Testing Suite... Setting Up Tests")
