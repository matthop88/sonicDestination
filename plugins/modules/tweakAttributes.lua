return {
    object           = nil,
    incAttributeKey  = nil,
    decAttributeKey  = nil,
    selectedUpKey    = "shifttab",
    selectedDownKey  = "tab",
    
    attributes       = {
        selectedIndex = 1,
        
        data = {
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

        mapToSelected = function(self, caller, fn, param)
            local index = 1
            for attName, attribute in pairs(self.data) do
                if attribute.active then
                    if index == self.selectedIndex then
                        fn(caller, attribute, attName, param)
                        return
                    end
                    index = index + 1
                end
            end
        end,
        
        normalizeSelectedIndex = function(self)
            local visibleCount = self:getVisibleCount()
            if     self.selectedIndex > visibleCount then self.selectedIndex = 1
            elseif self.selectedIndex < 1            then self.selectedIndex = visibleCount end
        end,

        getSelectedIndex = function(self)
            return self.selectedIndex
        end,

        incrementSelectedIndex = function(self)
            self.selectedIndex = self.selectedIndex + 1
            self:normalizeSelectedIndex()
        end,

        decrementSelectedIndex = function(self)
            self.selectedIndex = self.selectedIndex - 1
            self:normalizeSelectedIndex()
        end,
        
        getVisibleCount = function(self)
            local count = 0
            for _, attribute in pairs(self.data) do
                if attribute.active then count = count + 1 end
            end
            return count
        end,

        mapWithIndex = function(self, caller, fn, param)
            local index = 1
            for attName, attribute in pairs(self.data) do
                fn(caller, attribute, attName, index, param)
                if attribute.active then index = index + 1 end
            end
        end,
    },

    font = love.graphics.newFont(32),

    init = function(self, params)
        self.object          = params.object
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

        local yPosition = { value = 600 }
        self.attributes:mapWithIndex(self, self.drawAttribute, yPosition)
    end,

    drawAttribute = function(self, attribute, attName, index, yPosition)
        if index == self.attributes:getSelectedIndex() then love.graphics.setColor(1, 0, 0)
        else                                                love.graphics.setColor(1, 1, 1) end
        
        if attribute.active and attribute.getValueFn then
            love.graphics.printf((attribute.name or attName) .. " = " .. attribute:getValueFn(), 0, yPosition.value, 1024, "center")
            yPosition.value = yPosition.value + self.fontHeight
        end
    end,
    
    handleKeypressed = function(self, key)
        if     key == self.incAttributeKey then self:incrementActiveAttributes()
        elseif key == self.decAttributeKey then self:decrementActiveAttributes()
        elseif key == self.selectedUpKey   then self.attributes:decrementSelectedIndex()
        elseif key == self.selectedDownKey then self.attributes:incrementSelectedIndex()
        else                                    self:toggleAttributesFromKey(key)    end
    end,

    incrementActiveAttributes = function(self)      self.attributes:mapWithIndex(self, self.incrementAttribute)          end,
    decrementActiveAttributes = function(self)      self.attributes:mapWithIndex(self, self.decrementAttribute)          end,
    toggleAttributesFromKey   = function(self, key) self.attributes:mapWithIndex(self, self.toggleAttributeFromKey, key) end,
    
    incrementAttribute = function(self, attribute, attName, index)
        if attribute.active and attribute.incrementFn and index == self.attributes:getSelectedIndex() then attribute:incrementFn() end
    end,

    decrementAttribute = function(self, attribute, attName, index)
        if attribute.active and attribute.decrementFn and index == self.attributes:getSelectedIndex() then attribute:decrementFn() end
    end,

    toggleAttributeFromKey = function(self, attribute, attName, index, key)
        if key == attribute.toggleShowKey then attribute.active = not attribute.active end
        self.attributes:normalizeSelectedIndex()
    end,
}
