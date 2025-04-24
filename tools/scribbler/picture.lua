return {
    jots = {
        tailIndex = 0,

        draw = function(self)
            for n, jot in ipairs(self) do
                if n <= self.tailIndex then jot:draw() end
            end
        end,

        add = function(self, jot)
            self.tailIndex = self.tailIndex + 1
            self[self.tailIndex] = jot
        end,

        undo = function(self)
            self.tailIndex = math.max(0, self.tailIndex - 1)
        end,

        redo = function(self)
            self.tailIndex = math.min(#self, self.tailIndex + 1)
        end,
    },

    draw   = function(self)      self.jots:draw()   end,
    addJot = function(self, jot) self.jots:add(jot) end,
    undo   = function(self)      self.jots:undo()   end,
    redo   = function(self)      self.jots:redo()   end, 
    save   = function(self)
        printToReadout("Saving...")
    end,
}
