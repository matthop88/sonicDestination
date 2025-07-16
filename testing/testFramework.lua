local ASTERISKS     = "**********************************************************************************************************\n"

love.window.setTitle("Testing Suite... Setting Up Tests")

TESTING = {
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

                if self.testsClass.beforeAll then self.testsClass:beforeAll() end
                
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

    queueTestClasses = function(self, testClasses)
        self.queuedTestClasses = testClasses
    end,
    
    runAll = function(self)
        print("\nRunning Tests\n-------------")
    
        for _, testsClass in ipairs(self.queuedTestClasses) do
            self:initTests(testsClass)
            self:initiateTests(testsClass)
            self.runnableTests:run()
            self:showTestingSummary()
        end
        love.event.quit()
    end,

    initiateTests = function(self, testsClass)
        self:printTestName(testsClass)
        
        if testsClass.beforeAll then
            testsClass:beforeAll()
        end
    end,

    printTestName = function(self, testsClass)
        print(testsClass:getName() .. "\n" .. string.rep("-", string.len(testsClass:getName())))
    end,

    showTestingSummary = function(self, testsSucceeded)
        print("\nTests succeeded: " .. self.runnableTests.testsSucceeded .. " out of " .. self.runnableTests.testCount)
        if self.runnableTests.testsFailed > 0 then
            print("\n" .. self.runnableTests.testsFailed .. " tests FAILED.")
        end
        self:showFailedTestingDetails()
        print("\n")
    end,

    showFailedTestingDetails = function(self)
        if #self.runnableTests.errors > 0 then
            for _, error in ipairs(self.runnableTests.errors) do
                print("FAILED => " .. error.testName)
                print("          WITH ERROR: " .. error.err)
            end
        end
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

TESTING:queueTestClasses {
    require("testing/tests/testModKeyEnabler"),
    require("testing/tests/testPropertyNotifier"),
    require("testing/tests/testWidgetFactory"),
    require("testing/tests/testWidgets"),
}

require("testing/delayTests")
