local elementCount = 0

local tomatoCount = 0

local processElements = function(params, nextParams)
    if params.ELEMENT_LIST:isComplete() then
        return true
    else
        local nextElement = params.ELEMENT_LIST:next()
        nextParams:init {
            element = { name = nextElement, isCounted = false },
        }
    end
end

local countTomatoes = function(params, nextParams)
    if params.element.isCounted then
        return true
    end
    if params.element.name == "Tomato" then
        tomatoCount = tomatoCount + 1
    end

    nextParams:init {
        emptyPush = true,
    }
end

local countElement = function(params, nextParams)
    elementCount = elementCount + 1

    params.element.isCounted = true
    return true
end

return {

    PIPELINE_FACTORY = require("tools/lib/pipeline/pipeline"),
    FEEDER           = require("tools/lib/pipeline/feeder"),

    getName = function(self)
        return "Pipeline Tests"
    end,
    
    beforeAll = function(self)
        -- Do nothing
    end,

    before = function(self)
        self.PIPELINE = self.PIPELINE_FACTORY:create("Test Pipeline")
        elementCount = 0
        tomatoCount  = 0
    end,

    --------------- Tests ---------------

    testSimplePipeline = function(self)
        local name = "Test a simple two-stage pipeline which counts the number of elements in a list of words"
    
        local elementList = { "Apple", "Banana", "Tomato", }

        self.PIPELINE:add("Element Processor", processElements)
        self.PIPELINE:add("Element Counter",   countElement)
        self.PIPELINE:push({ ELEMENT_LIST = self.FEEDER:create("Element List", elementList) })

        local numExecutions = 0

        while (not self.PIPELINE:isComplete() and numExecutions < 100) do
            self.PIPELINE:execute(1)
            numExecutions = numExecutions + 1
        end

        return TESTING:assertEquals(name, "Number of Executions: 1, Element Count: 3",
            "Number of Executions: " .. numExecutions .. ", Element Count: " .. elementCount)
                                    
    end,  

    testThreeStagePipeline = function(self)
        local name = "Test a simple three-stage pipeline which counts the number of elements in a list of words and counts tomatoes."
    
        local elementList = { "Apple", "Banana", "Tomato", }

        self.PIPELINE:add("Element Processor", processElements)
        self.PIPELINE:add("Tomato Counter",    countTomatoes)
        self.PIPELINE:add("Element Counter",   countElement)
        self.PIPELINE:push({ ELEMENT_LIST = self.FEEDER:create("Element List", elementList) })

        local numExecutions = 0

        while (not self.PIPELINE:isComplete() and numExecutions < 100) do
            self.PIPELINE:execute(1)
            numExecutions = numExecutions + 1
        end

        return TESTING:assertEquals(name, "Number of Executions: 1, Element Count: 3, Tomato Count: 1",
            "Number of Executions: " .. numExecutions .. ", Element Count: " .. elementCount .. ", Tomato Count: " .. tomatoCount)
                                    
    end,  
}
