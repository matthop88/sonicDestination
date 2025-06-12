local ASTERISKS     = "**********************************************************************************************************\n"

love.window.setTitle("Testing Suite... Setting Up Tests")

return {
    initTests = function(self, testsClass)
        self.testsClass    = testsClass
        self.runnableTests = {}
        self.testCount     = 0

        for testName, test in pairs(testsClass) do
            if testName:sub(1, 4) == "test" then
                self.runnableTests[testName] = test
                self.testCount = self.testCount + 1
            end
        end
    end,

    runAll = function(self)
        print("\nRunning Tests\n-------------")

        if self.testsClass.beforeAll then
            self.testsClass:beforeAll()
        end
        
        local testsSucceeded = self:runTests()
        self:showTestingSummary(testsSucceeded)
        
        love.event.quit()
    end,

    runTests = function(self)
        local testsSucceeded = 0
        
        for testName, test in pairs(self.runnableTests) do
            if self:runTest(test, testName) then
                testsSucceeded = testsSucceeded + 1
            end
        end

        return testsSucceeded
    end,

    runTest = function(self, testFn, testName)
        self:runPretest()
        local status, err = pcall(function() testFn(self.testsClass) end)
        if not status then
            print("FAILED => " .. testName)
            print("          WITH ERROR: ", err, "\n")
        end
        return status
    end,

    runPretest = function(self)
        if self.testsClass.before then
            self.testsClass:before()
        end
    end,

    showTestingSummary = function(self, testsSucceeded)
        local testsFailed = self.testCount - testsSucceeded

        print("\nTests succeeded: " .. testsSucceeded .. " out of " .. self.testCount)
        if testsFailed > 0 then
            print("\n" .. testsFailed .. " tests FAILED.")
        end
        print("\n")
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
