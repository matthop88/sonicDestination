return {

    STACK = nil,
    
    getName = function(self)
        return "Stack Tests"
    end,
    
    beforeAll = function(self)
        -- Do nothing
    end,

    before = function(self)
        self.STACK = require("tools/lib/dataStructures/stack"):create()
    end,

    testEmptyListAttributes = function(self)
        local name = "Empty Stack Test"

        return TESTING:assertTrue(name, self.STACK:size() == 0
                                    and self.STACK:pop()  == nil)
    end,

    testSinglePush = function(self)
        local name = "Single Push Test",

        self.STACK:push(7)

        return TESTING:assertTrue(name, self.STACK:size() == 1
                                    and self.STACK:peek() == 7
                                    and self.STACK:pop()  == 7)
    end,
    
    testLIFO = function(self)
        local name = "Stack LIFO Test",

        self.STACK:push(1):push(2):push(3)
        
        return TESTING:assertTrue(name, self.STACK:pop()  == 3
                                    and self.STACK:pop()  == 2
                                    and self.STACK:pop()  == 1
                                    and self.STACK:size() == 0)
    end,                              

    testMultiplePushesAndPops = function(self)
        local name = "Stack multiple pushes and pops",

        self.STACK:push(1):push(2):push(3)
        self.STACK:pop()

        self.STACK:push(4):push(8):push(16)
        self.STACK:pop()
        self.STACK:pop()

        self.STACK:push(7):push(11):push(16)


        return TESTING:assertTrue(name, self.STACK:size() == 6
                                    and self.STACK:pop()  == 16
                                    and self.STACK:pop()  == 11
                                    and self.STACK:size() == 4
                                    and self.STACK:pop()  == 7
                                    and self.STACK:pop()  == 4
                                    and self.STACK:size() == 2
                                    and self.STACK:pop()  == 2
                                    and self.STACK:pop()  == 1
                                    and self.STACK:size() == 0)
    end,   

}
