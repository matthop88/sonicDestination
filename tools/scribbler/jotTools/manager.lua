return {
    scribbleTool = nil,
    lineTool     = nil,
    rectTool     = nil,
    textTool     = nil,

    currentTool  = nil,

    init = function(self, picture)
        self.scribbleTool = require("tools/scribbler/jotTools/scribble"):init(picture)
        self.lineTool     = require("tools/scribbler/jotTools/line"):init(picture)
        self.rectTool     = require("tools/scribbler/jotTools/rect"):init(picture)
        self.textTool     = require("tools/scribbler/jotTools/text"):init(picture)

        self.currentTool  = self.scribbleTool
    end,
    
    draw = function(self)
        -- ...
    end,

    update = function(self, dt)
        -- ...
    end,

    mousepressed = function(self, mx, my)
        -- ...
    end,

    mousereleased = function(self, mx, my)
        -- ...
    end,

    keypressed = function(self, key)
        -- ...
    end,
}
