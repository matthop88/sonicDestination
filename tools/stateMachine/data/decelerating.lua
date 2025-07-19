return {
    { type = "BOX",   label = "Stand Right",      x  = 12.5, y  =  5,   w  =  7, h =  4   },
    { type = "BOX",   label = "Stand Left",       x  = 12.5, y  = 14,   w  =  7, h =  4   },
    { type = "BOX",   label = "Accelerate Right", x  = 35,   y  =  5,   w  =  6, h = 13   },
    { type = "BOX",   label = "Accelerate Left",  x  =  1,   y  =  5,   w  =  6, h = 13   },
    { type = "ARROW", label = "R On",  from = "Stand Right",      to = "Accelerate Right", y =  6   },
    { type = "ARROW", label = "R Off", from = "Accelerate Right", to = "Stand Right",      y =  8   },
    { type = "ARROW", label = "L On",  from = "Stand Right",      to = "Accelerate Left",  y =  6   },
    { type = "ARROW", label = "R On",  from = "Accelerate Left",  to = "Accelerate Right", y = 10.5 },
    { type = "ARROW", label = "L On",  from = "Accelerate Right", to = "Accelerate Left",  y = 12.5 },
    { type = "ARROW", label = "L On",  from = "Stand Left",       to = "Accelerate Left",  y = 15   },
    { type = "ARROW", label = "L Off", from = "Accelerate Left",  to = "Stand Left",       y = 17   },
    { type = "ARROW", label = "R On",  from = "Stand Left",       to = "Accelerate Right", y = 15   },
}
