return {

    LINKED_LIST = nil,
    
    getName = function(self)
        return "Linked List Tests"
    end,
    
    beforeAll = function(self)
        -- Do nothing
    end,

    before = function(self)
        self.LINKED_LIST = require("tools/lib/dataStructures/linkedList"):create()
    end,

    testEmptyListAttributes = function(self)
        local name = "Empty List Test"

        return TESTING:assertTrue(name, self.LINKED_LIST:head():get() == nil
                                    and self.LINKED_LIST:tail():get() == nil
                                    and self.LINKED_LIST:get()        == nil
                                    and self.LINKED_LIST:next():get() == nil
                                    and self.LINKED_LIST:prev():get() == nil
                                    and self.LINKED_LIST:remove()     == nil
                                    and self.LINKED_LIST:isEnd()      == true
                                    and self.LINKED_LIST:size()       == 0)
    end,

    testSingleListElement = function(self)
        local name = "Single List Element Test",

        self.LINKED_LIST:add(3)

        return TESTING:assertTrue(name, self.LINKED_LIST:head():get() == 3
                                    and self.LINKED_LIST:tail():get() == 3
                                    and self.LINKED_LIST:get()        == 3
                                    and self.LINKED_LIST:isEnd()      == false
                                    and self.LINKED_LIST:size()       == 1
                                    and self.LINKED_LIST:remove()     == 3
                                    and self.LINKED_LIST:isEnd()      == true
                                    and self.LINKED_LIST:size()       == 0)
    end,
    
    testMultiElementListTraversal = function(self)
        local name = "Multiple List Element Traversal Test",

        self.LINKED_LIST:add(3)
        self.LINKED_LIST:add(5)
        self.LINKED_LIST:add(8)
        self.LINKED_LIST:add(13)

        return TESTING:assertTrue(name, self.LINKED_LIST:size()       == 4
                                    and self.LINKED_LIST:isEnd()      == false
                                    and self.LINKED_LIST:get()        == 3
                                    and self.LINKED_LIST:next():get() == 5
                                    and self.LINKED_LIST:next():get() == 8
                                    and self.LINKED_LIST:next():get() == 13
                                    and self.LINKED_LIST:next():get() == nil
                                    and self.LINKED_LIST:isEnd()      == true
                                    and self.LINKED_LIST:tail():get() == 13
                                    and self.LINKED_LIST:isEnd()      == false
                                    and self.LINKED_LIST:prev():get() == 8
                                    and self.LINKED_LIST:prev():get() == 5
                                    and self.LINKED_LIST:prev():get() == 3
                                    and self.LINKED_LIST:prev():get() == nil
                                    and self.LINKED_LIST:isEnd()      == true
                                    and self.LINKED_LIST:size()       == 4)

    end,                              

    testMultiElementListRemovalAndInsertion = function(self)
        local name = "Multiple List Element Removal and Insertion Test",

        self.LINKED_LIST:add(3)
        self.LINKED_LIST:add(5)
        self.LINKED_LIST:add(8)
        self.LINKED_LIST:add(13)

        return TESTING:assertTrue(name, self.LINKED_LIST:next():next():remove() == 8
                                    and self.LINKED_LIST:size()                 == 3
                                    and self.LINKED_LIST:get()                  == 13
                                    and self.LINKED_LIST:prev():insert(7):get() == 7
                                    and self.LINKED_LIST:size()                 == 4
                                    and self.LINKED_LIST:head():remove()        == 3
                                    and self.LINKED_LIST:size()                 == 3)

    end,     
}
