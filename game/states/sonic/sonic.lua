local SONIC, STATES

STATES = {
    STAND_LEFT       = "grounded/standLeft",
    STAND_RIGHT      = "grounded/standRight",
    ACCELERATE_LEFT  = "grounded/accelerateLeft",
    ACCELERATE_RIGHT = "grounded/accelerateRight",
    DECELERATE_LEFT  = "grounded/decelerateLeft",
    DECELERATE_RIGHT = "grounded/decelerateRight",
    BRAKE_LEFT       = "grounded/brakeLeft",
    BRAKE_RIGHT      = "grounded/brakeRight",
    
    init = function(self, params)
        SONIC = params.SONIC
        for k, v in pairs(self) do
            if type(v) == "string" then
                self[k] = requireRelative("states/sonic/" .. v, { SONIC = SONIC, STATES = STATES })
            end
        end
        return self
    end,
}

return STATES
