return {
    { type = "BOX",   label = "Stand Right", x  =  2, y  =  5,   w  =  9,        h =  4   },
    { type = "BOX",   label = "Stand Left",  x  = 21, y  = 14,   w  =  9,        h =  4   },
    { type = "BOX",   label = "Run Right",   x  = 21, y  =  5,   w  =  9,        h =  8   },
    { type = "BOX",   label = "Run Left",    x  =  2, y  = 10,   w  =  9,        h =  8   },
    { type = "ARROW", label = "R On",  from = "Stand Right", to = "Run Right",   y =  6   },
    { type = "ARROW", label = "R Off", from = "Run Right",   to = "Stand Right", y =  8   },
    { type = "ARROW", label = "R On",  from = "Run Left",    to = "Run Right",   y = 10.5 },
    { type = "ARROW", label = "L On",  from = "Run Right",   to = "Run Left",    y = 12.5 },
    { type = "ARROW", label = "L On",  from = "Stand Left",  to = "Run Left",    y = 15   },
    { type = "ARROW", label = "L Off", from = "Run Left",    to = "Stand Left",  y = 17   },
}
