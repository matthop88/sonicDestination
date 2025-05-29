return {
    object           = nil,
    incAttributeKey  = nil,
    decAttributeKey  = nil,
    selectedUpKey    = "shifttab",
    selectedDownKey  = "tab",
    
    attributes       = { 
--[[    
        <nameOfAttribute> = {
            name = "Optional Readable Attribute Name",
            incrementFn = function()
                ... code to increment value of attribute
            end,
            decrementFn = function()
                ... code to decrement value of attribute
            end,
            getValueFn() = function()
                ... code to return value of attribute
            end,
            toggleShowKey = "keyToToggleAttribute",
        },
        ...     
--]]
    },

    selectedAttributeIndex = 1,

    font = love.graphics.newFont(32),

    init = function(self, params)
        self.object          = params.object
        self.incAttributeKey = params.incAttributeKey
        self.decAttributeKey = params.decAttributeKey
        self.attributes      = params.attributes
        self.selectedUpKey   = params.selectedUpKey   or self.selectedUpKey
        self.selectedDownKey = params.selectedDownKey or self.selectedDownKey
        self.fontHeight      = self.font:getHeight()

        return self
    end,

    draw = function(self)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(self.font)

        local yPosition = { value = 600 }
        self:mapToAttributesWithIndex(self.drawAttribute, yPosition)
    end,

    mapToAttributesWithIndex = function(self, fn, param)
        local index = 1
        for attName, attribute in pairs(self.attributes) do
            fn(self, attribute, attName, index, param)
            if attribute.active then index = index + 1 end
        end
    end,

    drawAttribute = function(self, attribute, attName, index, yPosition)
        if index == self.selectedAttributeIndex then love.graphics.setColor(1, 0, 0)
        else                                         love.graphics.setColor(1, 1, 1) end
        
        if attribute.active and attribute.getValueFn then
            love.graphics.printf((attribute.name or attName) .. " = " .. attribute:getValueFn(), 0, yPosition.value, 1024, "center")
            yPosition.value = yPosition.value + self.fontHeight
        end
    end,
    
    handleKeypressed = function(self, key)
        if     key == self.incAttributeKey then self:incrementActiveAttributes()
        elseif key == self.decAttributeKey then self:decrementActiveAttributes()
        elseif key == self.selectedUpKey   then 
            self.selectedAttributeIndex = self.selectedAttributeIndex - 1
            self:normalizeSelectedAttributeIndex(self:countVisibleAttributes())
        elseif key == self.selectedDownKey then 
            self.selectedAttributeIndex = self.selectedAttributeIndex + 1
            self:normalizeSelectedAttributeIndex(self:countVisibleAttributes())
        else                                    
            self:toggleAttributesFromKey(key)                         
        end
    end,

    countVisibleAttributes = function(self)
        local count = 0
        for _, attribute in pairs(self.attributes) do
            if attribute.active then count = count + 1 end
        end
        return count
    end,

    normalizeSelectedAttributeIndex = function(self, numberOfVisibleAttributes)
        if     self.selectedAttributeIndex > numberOfVisibleAttributes then 
            self.selectedAttributeIndex = 1
        elseif self.selectedAttributeIndex < 1 then 
            self.selectedAttributeIndex = numberOfVisibleAttributes 
        end
    end,
    
    incrementActiveAttributes = function(self)      self:mapToAttributesWithIndex(self.incrementAttribute)          end,
    decrementActiveAttributes = function(self)      self:mapToAttributesWithIndex(self.decrementAttribute)          end,
    toggleAttributesFromKey   = function(self, key) self:mapToAttributesWithIndex(self.toggleAttributeFromKey, key) end,
    
    incrementAttribute = function(self, attribute, attName, index)
        if attribute.active and attribute.incrementFn and index == self.selectedAttributeIndex then attribute:incrementFn() end
    end,

    decrementAttribute = function(self, attribute, attName, index)
        if attribute.active and attribute.decrementFn and index == self.selectedAttributeIndex then attribute:decrementFn() end
    end,

    toggleAttributeFromKey = function(self, attribute, attName, index, key)
        if key == attribute.toggleShowKey then attribute.active = not attribute.active end
    end,
}
