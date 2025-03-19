COLOR = {
    JET_BLACK         = { 0,   0,   0      },
    TRANSPARENT_BLACK = { 0,   0,   0, 0.5 },
    TRANSPARENT_BLUE  = { 0,   0,   1, 0.5 },
    PURE_WHITE        = { 1,   1,   1      },
    TRANSLUCENT_WHITE = { 1,   1,   1, 0.5 },
    TRANSPARENT_WHITE = { 1,   1,   1, 0.1 },
    RED               = { 1,   0,   0      },
    YELLOW            = { 1,   1,   0      },
    MEDIUM_GREY       = { 0.5, 0.5, 0.5    },
}

function compareColors(color1, color2)
    if color1 == nil or color2 == nil then 
        return false 
    end
    
    return color1[1] == color2[1] and color1[2] == color2[2] and color1[3] == color2[3]
end

