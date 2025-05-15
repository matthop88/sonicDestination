return {
    object           = nil,
    incAttributeKey  = nil,
    decAttributeKey  = nil,
    attributes       = { },

    font             = love.graphics.newFont(32),

    init             = function(self, params)
        self.object          = params.object
        self.incAttributeKey = params.incAttributeKey
        self.decAttributeKey = params.decAttributeKey
        self.attributes      = params.attributes

        self.fontHeight      = self.font:getHeight()

        return self
    end,

    draw             = function(self)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(self.font)

        local yPosition = 600
        
        for attName, attribute in pairs(self.attributes) do
            if attribute.active and attribute.getValueFn then
                love.graphics.printf(attName .. " = " .. attribute:getValueFn(), 0, yPosition, 1024, "center")
                yPosition = yPosition + self.fontHeight
            end
        end
    end,
    
    handleKeypressed = function(self, key)
        if     key == self.incAttributeKey then self:incrementActiveAttributes()
        elseif key == self.decAttributeKey then self:decrementActiveAttributes()
        else                                    self:toggleAttributesFromKey(key)
        end
    end,

    mapToAttributes = function(self, fn, param)
        for attName, attribute in pairs(self.attributes) do
            fn(self, attribute, param)
        end
    end,
    
    incrementActiveAttributes = function(self)      self:mapToAttributes(self.incrementAttribute)          end,
    decrementActiveAttributes = function(self)      self:mapToAttributes(self.decrementAttribute)          end,
    toggleAttributesFromKey   = function(self, key) self:mapToAttributes(self.toggleAttributeFromKey, key) end,
    
    incrementAttribute = function(self, attribute)
        if attribute.active and attribute.incrementFn then attribute:incrementFn()     end
    end,

    decrementAttribute = function(self, attribute)
        if attribute.active and attribute.decrementFn then attribute:decrementFn()     end
    end,

    toggleAttributeFromKey = function(self, attribute, key)
        if key == attribute.toggleShowKey then attribute.active = not attribute.active end
    end,
}
