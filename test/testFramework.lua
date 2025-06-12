local ASTERISKS     = "**********************************************************************************************************\n"

love.window.setTitle("Testing Suite... Setting Up Tests")

return {
    initTests = function(self, testsClass)
        self.runnableTests = {
            testsClass = testsClass,
            tests  = { },
            errors = { },

            testCount      = 0,
            testsSucceeded = 0,
            testsFailed    = 0,

            add = function(self, testName, testFn)
                self.tests[testName] = testFn
                self.testCount = self.testCount + 1
            end,

            run = function(self)
                self.testsSucceeded, self.testsFailed = 0, 0
                self.errors = {}

                for testName, testFn in pairs(self.tests) do
                    self:runTest(testFn, testName)
                end
            end,

            runTest = function(self, testFn, testName)
                self:runPretest()
                local testResult = false
                local status, err = pcall(function() testResult = testFn(self.testsClass) end)
                if status == true then
                    if testResult == true then self.testsSucceeded = self.testsSucceeded + 1
                    else                       self.testsFailed    = self.testsFailed    + 1 end
                else
                    print("Test failed: " .. testName .. " with error: " .. err)
                    table.insert(self.errors, { testName = testName, err = err })
                    self.testsFailed = self.testsFailed + 1
                end
            end,

            runPretest = function(self)
                if testsClass.before then
                    testsClass:before()
                end
            end,
        }
        
        for testName, fn in pairs(testsClass) do
            if testName:sub(1, 4) == "test" then
                self.runnableTests:add(testName, fn)
            end
        end
    end,

    runAll = function(self)
        print("\nRunning Tests\n-------------")
        self.runnableTests:run()
        self:showTestingSummary()
        
        love.event.quit()
    end,

    showTestingSummary = function(self, testsSucceeded)
        
        print("\nTests succeeded: " .. self.runnableTests.testsSucceeded .. " out of " .. self.runnableTests.testCount)
        if self.runnableTests.testsFailed > 0 then
            print("\n" .. self.runnableTests.testsFailed .. " tests FAILED.")
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
