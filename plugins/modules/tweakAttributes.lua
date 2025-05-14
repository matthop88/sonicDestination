return {
    object           = nil,
    incAttributeKey  = nil,
    decAttributeKey  = nil,
    attributes       = { },

    init             = function(self, params)
        self.object          = params.object
        self.incAttributeKey = params.incAttributeKey
        self.decAttributeKey = params.decAttributeKey
        self.attributes      = params.attributes

        return self
    end,

    handleKeypressed = function(self, key)
        -- Check to see if key matches toggleShowKey on any attribute
        for attName, attribute in pairs(self.attributes) do
            if key == attribute.toggleShowKey then
                attribute.active = not attribute.active
                print("Attribute " .. attName .. " is active: ", attribute.active)
            end
        end
    end,
}
