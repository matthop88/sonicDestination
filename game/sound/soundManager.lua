return ({
    init = function(self)
        return self
    end,

    data = {
        sonicBraking = { 
            filename = "brake.ogg",
            sound    = nil,

            load     = function(self)
                -- Load sound from file
            end,
        },
    },
}):init()
