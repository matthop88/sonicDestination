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
        local name = "Empty List Test: head = false, tail = false, get = nil, next = self, prev = self, remove = self, isEnd = true, size = 0"

        return TESTING:assertTrue(name, self.LINKED_LIST:head()   == false
                                    and self.LINKED_LIST:tail()   == false
                                    and self.LINKED_LIST:get()    == nil
                                    and self.LINKED_LIST:next()   == self.LINKED_LIST
                                    and self.LINKED_LIST:prev()   == self.LINKED_LIST
                                    and self.LINKED_LIST:remove() == nil
                                    and self.LINKED_LIST:isEnd()  == true
                                    and self.LINKED_LIST:size()   == 0)
    end,

    testSingleListElement = function(self)

        local name = "Single List Element Test",

        self.LINKED_LIST:add(3)

        return TESTING:assertTrue(name, self.LINKED_LIST:head()   == true
                                    and self.LINKED_LIST:tail()   == true
                                    and self.LINKED_LIST:get()    == 3
                                    and self.LINKED_LIST:next()   == self.LINKED_LIST
                                    and self.LINKED_LIST:prev()   == self.LINKED_LIST
                                    and self.LINKED_LIST:isEnd()  == false
                                    and self.LINKED_LIST:size()   == 1
                                    and self.LINKED_LIST:remove() == 3
                                    and self.LINKED_LIST:isEnd()  == true
                                    and self.LINKED_LIST:size()   == 0)
    end,
                                    

}
