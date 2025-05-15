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

        return self
    end,

    draw             = function(self)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(self.font)
        
        for attName, attribute in pairs(self.attributes) do
            if attribute.active and attribute.getValueFn then
                love.graphics.printf(attName .. " = " .. attribute:getValueFn(), 0, 600, 1024, "center")
            end
        end
    end,
    
    handleKeypressed = function(self, key)
        -- Check to see if key matches toggleShowKey on any attribute
        for attName, attribute in pairs(self.attributes) do
            if key == attribute.toggleShowKey then
                attribute.active = not attribute.active
            end
        end
    end,
}
