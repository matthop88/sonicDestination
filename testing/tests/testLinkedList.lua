return {

    LINKED_LIST = nil,
    
    getName = function(self)
        return "Linked List Tests"
    end,
    
    beforeAll = function(self)
        -- Do nothing
    end,

    before = function(self)
        self.LINKED_LIST = require("tools/lib/dataStructures/linkedList")
    end,

    testEmptyListAttributes = function(self)
        local name = "Empty List Test: head = nil, tail = nil, get = nil, next = nil, prev = nil, remove = nil, size = 0"

        return TESTING:assertTrue(name, self.LINKED_LIST:head()   == nil
                                    and self.LINKED_LIST:tail()   == nil
                                    and self.LINKED_LIST:get()    == nil
                                    and self.LINKED_LIST:next()   == nil
                                    and self.LINKED_LIST:prev()   == nil
                                    and self.LINKED_LIST:remove() == nil
                                    and self.LINKED_LIST:size()   == 0)
    end,

}
