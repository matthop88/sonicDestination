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
    end,

    --------------- Tests ---------------

    testSimplePipeline = function(self)
        local name = "Test a simple two-stage pipeline which counts the number of elements in a list of words"
    
        local elementList = { "Apple", "Banana", "Tomato", }

        local elementCount = 0

        local processElements = function(results, dataIn, dataOut)
            if dataIn.ELEMENT_LIST:isComplete() then
                return { completed = true }
            else
                dataOut.element = dataIn.ELEMENT_LIST:next()
            end
        end

        local countElement = function(results, dataIn, dataOut)
            elementCount = elementCount + 1

            return { completed = true }
        end
                
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
}
