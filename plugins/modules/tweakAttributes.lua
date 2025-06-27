return {
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

        getSelectedIndex       = function(self) return self.selectedIndex                     end,
        incrementSelectedIndex = function(self) self:setSelectedIndex(self.selectedIndex + 1) end,
        decrementSelectedIndex = function(self) self:setSelectedIndex(self.selectedIndex - 1) end,

        setSelectedIndex = function(self, selectedIndex)
            self.selectedIndex = selectedIndex
            local visibleCount = self:getVisibleCount()
            if     self.selectedIndex > visibleCount then self.selectedIndex = 1
            elseif self.selectedIndex < 1            then self.selectedIndex = visibleCount end
        end,

        getVisibleCount = function(self)
            local count = 0
            for _, attribute in pairs(self.data) do
                if attribute.active then count = count + 1 end
            end
            return count
        end,
        
        incrementSelectedValue = function(self) self:mapActive(self:createCallback(self.incrementAttribute))  end,
        decrementSelectedValue = function(self) self:mapActive(self:createCallback(self.decrementAttribute))  end,

        createCallback = function(self, fn, params) return { caller = self, fn = fn, params = params or { } } end,   
    
        mapActive      = function(self, callback)
            local index = 1
            for attName, attribute in pairs(self.data) do
                if attribute.active then 
                    callback.params.isSelected = (index == self.selectedIndex)
                    callback.fn(callback.caller or self, attribute, attName, callback.params)
                    index = index + 1
                end
            end
        end,

        incrementAttribute = function(self, attribute, attName, params)
            if attribute.active and attribute.incrementFn and params.isSelected then attribute:incrementFn() end
        end,

        decrementAttribute = function(self, attribute, attName, params)
            if attribute.active and attribute.decrementFn and params.isSelected then attribute:decrementFn() end
        end,

        toggleByKey = function(self, key) self:mapAll( self:createCallback(self.toggleAttributeFromKey, { key = key })) end,

        mapAll = function(self, callback)
            callback.params.isSelected = true
            for attName, attribute in pairs(self.data) do
                callback.fn(callback.caller or self, attribute, attName, callback.params)
            end
        end,

        activateSpecialByKey = function(self, key)
            self:mapAll( { fn = self.triggerSpecialFnFromKey, params = { key = key } } )
        end,
        
        toggleAttributeFromKey = function(self, attribute, attName, params)
            if params.key == attribute.toggleShowKey then attribute.active = not attribute.active end
            self:updateSelectedIndex()
        end,

        triggerSpecialFnFromKey = function(self, attribute, attName, params)
            if attribute.special and params.key == attribute.special.key then
                attribute.special.fn()
            end
        end,

        updateSelectedIndex = function(self) self:setSelectedIndex(self.selectedIndex) end,
    },

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
        if params.isSelected then love.graphics.setColor(1, 0, 0)
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
