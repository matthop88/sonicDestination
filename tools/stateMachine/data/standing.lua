return {
    x = 0, y = 0, scale = 1,
    { type = "BOX",   label = "Stand Left",  x  =  4, w  =  9,   h  =  7,            y =  7 },
    { type = "BOX",   label = "Stand Right", x  = 20, w  =  9,   h  =  7,            y =  7 },
    { type = "ARROW", label = "L On",      from = "Stand Right", to = "Stand Left",  y =  9 },
    { type = "ARROW", label = "R On",      from = "Stand Left",  to = "Stand Right", y = 12 },
}
