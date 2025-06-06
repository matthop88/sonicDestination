local IDLE_TIMER_MAX = 120

return {
    mousePosition = require("tools/scribbler/utils/mousePosition"),
    scribbleTool  = nil,
    lineTool      = nil,
    rectTool      = nil,
    textTool      = nil,

    currentTool   = nil,

    toolsByKey    = { },

    idleTimer     = IDLE_TIMER_MAX,

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
        local mx, my = self.mousePosition:get()
        self.currentTool:draw(mx, my)
        if not self:isIdle() then
            self.currentTool:drawCursor(mx, my, 1)
        end
    end,

    update = function(self, dt)
        self.mousePosition:update(dt)
        self:updateIdleTimer(dt)

        if self.mousePosition:isChanged() then
            self:dragOrMoveCurrentToolPen(self.mousePosition:get())
        end
    end,

    updateIdleTimer = function(self, dt)
        self.idleTimer = self.idleTimer - (dt * 60)
        if self.mousePosition:isChanged() then
            self:resetIdleTimer()
        end
    end,

    resetIdleTimer = function(self)
        self.idleTimer = IDLE_TIMER_MAX
    end,

    isIdle = function(self)
        return self.idleTimer <= 0
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
        self:resetIdleTimer()
        if     self.toolsByKey[key] then self.currentTool = self.toolsByKey[key]
        elseif key == "x"           then self:printMousePositionInGridCoordinates()
        else                             self:handleToolKey(key)              end
    end,

    printMousePositionInGridCoordinates = function(self)
        local mx, my = love.mouse.getPosition()
        printToReadout("X = " .. math.floor(mx / 32) .. ", Y = " .. math.floor(my / 32))
    end,
    
    handleToolKey = function(self, key)
        if self.currentTool.keypressed then 
            self.currentTool:keypressed(key)
        end
    end, 
}
