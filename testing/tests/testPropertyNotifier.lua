local PROP_LOADER = require("game/properties/loader")

local LISTENER_A = {
    onPropertyChange = function(self, propData)
        -- do nothing
    end,
}

local LISTENER_B = {
    onPropertyChange = function(self, propData)
        -- do nothing
    end,
}

return {
    getName = function(self)
        return "Property Notifier Tests"
    end,
    
    beforeAll = function(self)
        self.propertyNotifier = PROP_LOADER:getNotifier()
    end,

    before = function(self)
        self.propertyNotifier:clearListeners()
    end,

    --------------- Tests ---------------

    testMultipleNotifications = function(self)
        local name = "Add Listeners A, B. Listeners list should contain A and B"
        PROP_LOADER:notifyOnChange(LISTENER_A)
        PROP_LOADER:notifyOnChange(LISTENER_B)

        local listeners = self.propertyNotifier:getListeners()

        return TESTING:assertTrue(name, #listeners == 2 and listeners[1] == LISTENER_A and listeners[2] == LISTENER_B)
    end,

    testUniqueNotifications = function(self)
        local name = "Add Listeners A, B, A, B, B. Listeners list should contain A and B"
        PROP_LOADER:notifyOnChange(LISTENER_A)
        PROP_LOADER:notifyOnChange(LISTENER_B)
        PROP_LOADER:notifyOnChange(LISTENER_A)
        PROP_LOADER:notifyOnChange(LISTENER_B)
        PROP_LOADER:notifyOnChange(LISTENER_B)

        local listeners = self.propertyNotifier:getListeners()

        return TESTING:assertTrue(name, #listeners == 2 and listeners[1] == LISTENER_A and listeners[2] == LISTENER_B)
    end,
}
