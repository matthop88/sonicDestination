return {
    imageName  = "commonObj",
    animations  = {
        spinning = { fps = 8, offset = { x = 8, y = 8 }, w = 16, h = 16, synchronized = true, isDefault = true,
            ---------------------------------------------------------------------------------------------------
            { x =  24, y = 198, w = 16, h = 16, offset = { x =  8, y =  8 }, },
            { x =  48, y = 198, w = 16, h = 16, offset = { x =  8, y =  8 }, },
            { x =  72, y = 198, w =  8, h = 16, offset = { x =  4, y =  8 }, },
            { x =  88, y = 198, w = 16, h = 16, offset = { x =  8, y =  8 }, },
        },
        dissolving = { fps = 8, offset = { x = 8, y = 7 }, w = 16, h = 14, foreground = true,
            { x = 112, y = 198, w = 16, h = 14, offset = { x =  8, y =  7 }, },
            { x = 136, y = 200, w = 16, h = 14, offset = { x =  8, y =  7 }, },
            { x = 160, y = 198, w = 16, h = 14, offset = { x =  8, y =  7 }, },
            { x = 184, y = 200, w = 16, h = 14, offset = { x =  8, y =  7 }, },
        },
    },
}
