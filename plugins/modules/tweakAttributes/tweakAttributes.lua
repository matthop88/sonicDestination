return {
    incAttributeKey  = nil,
    decAttributeKey  = nil,
    selectedUpKey    = "shifttab",
    selectedDownKey  = "tab",
    
    attributes       = require("plugins/modules/tweakAttributes/attributes"),

    font = love.graphics.newFont(32),

    init = function(self, params)
        self.incAttributeKey = params.incAttributeKey
        self.decAttributeKey = params.decAttributeKey
        self.attributes.data = params.attributes
        self.selectedUpKey   = params.selectedUpKey   or self.selectedUpKey
        self.selectedDownKey = params.selectedDownKey or self.selectedDownKey
        self.fontHeight      = self.font:getHeight()

        return self
    end,

    draw = function(self)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(self.font)
        self.attributes:mapActive(self:createCallback(self.drawAttribute, { yPosition = 600 }))
    end,

    drawAttribute = function(self, attribute, attName, params)
        if params.isSelected then love.graphics.setColor(1, 1, 0)
        else                      love.graphics.setColor(1, 1, 1) end
        
        if attribute.getValueFn then
            love.graphics.printf((attribute.name or attName) .. " = " .. attribute:getValueFn(), 0, params.yPosition, 1024, "center")
            params.yPosition = params.yPosition + self.fontHeight
        end
    end,
    
    createCallback = function(self, fn, params) return { caller = self, fn = fn, params = params or { } } end,
    
    handleKeypressed = function(self, key)
        if     key == self.incAttributeKey then self.attributes:incrementSelectedValue()
        elseif key == self.decAttributeKey then self.attributes:decrementSelectedValue()
        elseif key == self.selectedUpKey   then self.attributes:decrementSelectedIndex()
        elseif key == self.selectedDownKey then self.attributes:incrementSelectedIndex()
        else                                   
            self.attributes:toggleByKey(key)
            self.attributes:activateSpecialByKey(key)
        end
    end,
}
