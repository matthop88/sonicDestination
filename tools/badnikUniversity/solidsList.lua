return {
    solids = require("tools/lib/dataStructures/linkedList"):create(),  
     
    selectedSolid       = nil,
    consideredSolid     = nil,
   
    draw = function(self, GRAFX)
        self.solids:forEach(function(solid) self:drawSolidAt(solid.x, solid.y, GRAFX) end)
    end,

    drawSolidAt = function(self, x, y, GRAFX)
        GRAFX:setColor(0.5, 1, 1)
        GRAFX:setLineWidth(2)
        GRAFX:line(x, y, x + 16, y)
    end,

    drawMouseOver = function(self, GRAFX)
        local c = self.consideredSolid
        if c then
            GRAFX:setColor(0.5, 0.5, 1)
            GRAFX:setLineWidth(1)
            GRAFX:rectangle("line", c.x - 1, c.y - 2, 18, 4)
        end
    end,

    drawSelected = function(self, GRAFX)
        local s = self.selectedSolid
        if s then
            GRAFX:setColor(1, 1, 1)
            GRAFX:setLineWidth(2)
            GRAFX:rectangle("line", s.x - 1, s.y - 2, 18, 4)
        end
    end,

    drawCursor = function(self, GRAFX)
        love.mouse.setVisible(false)
        local x, y = self:quantizeLineCoordinates(GRAFX:screenToImageCoordinates(love.mouse.getPosition()))
        GRAFX:setColor(1, 1, 0, 0.7)
        GRAFX:setLineWidth(2)
        GRAFX:line(x, y, x + 16, y)
    end,

    calculateMouseOver = function(self, GRAFX) 
        self.consideredSolid = nil
        local x, y = GRAFX:screenToImageCoordinates(love.mouse.getPosition())

        self.solids:forEach(function(solid)
            if self:isInside(x, y, solid) then
                self.consideredSolid = solid
                return true
            end
        end)
    end,

    update = function(self, dt, GRAFX)
        self:calculateMouseOver(GRAFX)
    end,

    isInside = function(self, x, y, solid)
        return solid.x <= x and solid.x + 16 > x and solid.y - 2 <= y and solid.y + 3 > y
    end,

    add = function(self, x, y)
        x, y = self:quantizeLineCoordinates(x, y)
        if not self:findSolid(x, y) then
            self.solids:add({ x = x, y = y })
        end
    end,

    findSolid = function(self, x, y)
        local preexistingSolid = nil
        self.solids:forEach(function(solid)
            if solid.x == x and solid.y == y then
                preexistingSolid = solid
                return true
            end
        end)
        return preexistingSolid
    end,

    selectSolidAt = function(self, mx, my, GRAFX)
        local x, y = GRAFX:screenToImageCoordinates(mx, my)

        self:deselect()
        self.solids:forEach(function(solid)
            if self:isInside(x, y, solid) then
                self.selectedSolid = solid
                return true
            end
        end)

        return self.selectedSolid ~= nil
    end,

    deselect = function(self)
        self.selectedSolid = nil
    end,

    deleteSelected = function(self)
        self.solids:forEach(function(solid)
            if self.selectedSolid == solid then
                self:deselect()
                self.solids:remove()
                return true
            end
        end)
    end,

    quantizeLineCoordinates = function(self, x, y)
        return math.floor((x + 8) / 16) * 16, math.floor((y + 8) / 16) * 16
    end,

    getStringData = function(self)
        local stringData = "{\n"
        self.solids:forEach(function(solid)
            stringData = stringData .. "  { x = " .. solid.x .. ", y = " .. solid.y .. " },\n"
        end)

        return stringData .. "}\n"
    end,
}
