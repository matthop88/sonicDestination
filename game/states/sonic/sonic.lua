local SONIC, STATES

STATES = {
    STAND_LEFT       = "standLeft",
    STAND_RIGHT      = "standRight",
    ACCELERATE_LEFT  = "accelerateLeft",
    ACCELERATE_RIGHT = "accelerateRight",
    
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
