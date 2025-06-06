return {
    mousePosition = require("tools/scribbler/utils/mousePosition"),
    scribbleTool  = nil,
    lineTool      = nil,
    rectTool      = nil,
    textTool      = nil,

    currentTool   = nil,

    toolsByKey    = { },

    init = function(self, picture)
        self:initTools(picture)
        self:initToolsByKey()
        self.currentTool = self.scribbleTool
        return self
    end,

    initTools = function(self, picture)
        self.scribbleTool = require("tools/scribbler/jotTools/scribble"):init(picture)
        self.lineTool     = require("tools/scribbler/jotTools/line"):init(picture)
        self.rectTool     = require("tools/scribbler/jotTools/rect"):init(picture)
        self.textTool     = require("tools/scribbler/jotTools/text"):init(picture)
    end,

    initToolsByKey = function(self)
        self.toolsByKey = {
            s = self.scribbleTool,    l = self.lineTool,
            r = self.rectTool,        t = self.textTool,
        }
    end,
    
    draw = function(self)
        self.currentTool:draw(self.mousePosition:get())
    end,

    update = function(self, dt)
        if self.currentTool.setIdle then
            self.currentTool:setIdle(self.mousePosition:isIdle())
        end
            
        self.mousePosition:update(dt)

        if self.mousePosition:isChanged() then
            self:dragOrMoveCurrentToolPen(self.mousePosition:get())
        end
    end,
    
    dragOrMoveCurrentToolPen = function(self, mx, my)
        if love.mouse.isDown(1) then self.currentTool:penDragged(mx, my)
        else                         self.currentTool:penMoved(mx, my)   end
    end,

    mousepressed = function(self, mx, my)
        self.currentTool:penDown(self.mousePosition:get())
    end,

    mousereleased = function(self, mx, my)
        self.currentTool:penUp(self.mousePosition:get())
    end,

    keypressed = function(self, key)
        self.mousePosition:resetIdle()
        if self.toolsByKey[key] then self.currentTool = self.toolsByKey[key]
        else                         self:handleToolKey(key)            end
    end,

    handleToolKey = function(self, key)
        if     key == "x"                  then self:printMousePositionInGridCoordinates()
        elseif self.currentTool.keypressed then self.currentTool:keypressed(key)     end
    end,

    printMousePositionInGridCoordinates = function(self)
        local mx, my = love.mouse.getPosition()
        printMessage("X = " .. math.floor(mx / 32) .. ", Y = " .. math.floor(my / 32))
    end,
    
}
