return {
    jotFactory = require("tools/scribbler/jotFactory"),

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

        save = function(self)
            local version = "0.1"
            
            local serializedJots = "return { version = \"" .. version .. "\", \n"
            for n, jot in ipairs(self) do
                if n <= self.tailIndex then
                    serializedJots = serializedJots .. jot:toString()
                end
            end
            serializedJots = serializedJots .. "\n}"
            local success, message = love.filesystem.write( "scribble.lua", serializedJots)

            if success then
                print("File created in " .. love.filesystem.getSaveDirectory())
                printToReadout("File Saved: " .. string.len(serializedJots) .. " bytes")
            else
                print("File not created: " .. message)
                printToReadout("ERROR when saving!")
            end
        end,
    },

    draw   = function(self)      self.jots:draw()   end,
    addJot = function(self, jot) self.jots:add(jot) end,
    undo   = function(self)      self.jots:undo()   end,
    redo   = function(self)      self.jots:redo()   end,
    save   = function(self)      self.jots:save()   end,

    load   = function(self, filename)
        local fileData = require("tools/scribbler/data/" .. filename)
        for _, jotData in ipairs(fileData) do
            self:addJot(self.jotFactory:createJot(jotData.name, jotData.data))
        end
    end,
}
