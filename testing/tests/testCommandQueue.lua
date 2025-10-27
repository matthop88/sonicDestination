return {

    commandQueue = require("tools/chunkDoctor/command/queue"):create(),
    
    getName = function(self)
        return "Command Queue Tests"
    end,
    
    beforeAll = function(self)
        -- Do nothing
    end,

    before = function(self)
        self.commandQueue:empty()
    end,

    loadQueue = function(self)
        self.commandQueue:add(1)
        self.commandQueue:add(2)
        self.commandQueue:add(3)
    end,

    testQueueAdd = function(self)
        local name = "Size Test:       After adding 1, 2, 3 to queue, should have size of 3"

        self:loadQueue()

        return TESTING:assertEquals(name, 3, self.commandQueue:size())
    end,

    testQueueGetNothing = function(self)
        local name = "Empty Get Test:  After adding 1, 2, 3 to queue, get() should return nil"

        self:loadQueue()

        return TESTING:assertEquals(name, nil, self.commandQueue:get())
    end,

    testQueuePrevGet3 = function(self)
        local name = "Prev Get 3 Test: After adding 1, 2, 3 to queue, prev() should return 3",

        self:loadQueue()
        return TESTING:assertEquals(name, 3, self.commandQueue:prev())
    end,

    testQueueNextGetNothing = function(self)
        local name = "Next Get nil Test: After adding 1, 2, 3 to queue, next() should return nil",

        self:loadQueue()
        return TESTING:assertEquals(name, nil, self.commandQueue:next())
    end,

    testQueuePrevx3Get1 = function(self)
        local name = "Prev x 3 Get 1 Test: After adding 1, 2, 3 to queue, prev() called 3x should return 1 on the 3rd call",

        self:loadQueue()
        local queueResult = 0
        for i = 1, 3 do queueResult = self.commandQueue:prev() end

        return TESTING:assertEquals(name, 1, queueResult)
    end,

    testQueuePrevx4GetNothing = function(self)
        local name = "Prev x 4 Get nil Test: After adding 1, 2, 3 to queue, prev() called 4x should return nil on the 4th call",

        self:loadQueue()
        local queueResult = 0
        for i = 1, 4 do queueResult = self.commandQueue:prev() end

        return TESTING:assertEquals(name, nil, queueResult)
    end,

    testQueuePrevx3Add1Size1 = function(self)
        local name = "Prev x 3 Add 1 Size 1 Test: After adding 1, 2, 3 to queue, prev() called 3x followed by adding a number should give us a size of 1",

        self:loadQueue()
        for i = 1, 3 do queueResult = self.commandQueue:prev() end
        self.commandQueue:add(7)

        return TESTING:assertEquals(name, 1, self.commandQueue:size())
    end,

    testQueuePrevx3Add1NextNothing = function(self)
        local name = "Prev x 3 Add 1 Next nil Test: After adding 1, 2, 3 to queue, prev() called 3x followed by adding a number should give us a next() of nil",

        self:loadQueue()
        for i = 1, 3 do queueResult = self.commandQueue:prev() end
        self.commandQueue:add(7)

        return TESTING:assertEquals(name, nil, self.commandQueue:next())
    end,

    testQueuePrevx3Nextx2Get2 = function(self)
        local name = "Prev x 3 Next x 2 Get 2 Test: After adding 1, 2, 3 to queue, prev() called 3x followed by next() called 2x should return 2 on the 2nd call",

        self:loadQueue()
        for i = 1, 3 do queueResult = self.commandQueue:prev() end
        self.commandQueue:next()

        return TESTING:assertEquals(name, 2, self.commandQueue:next())
    end,
}
