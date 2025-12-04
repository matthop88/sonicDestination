return {
  sourceImage      = "resources/zones/maps/SCD_PTP_Map_Act1.png",
  origin           = { x = 56,  y = 238,  },
  -------------------------------------------
  { obj = "giantRing", x = 963, y = 128, inactive = true, 
    destination = { 
      { map = "ghz1Map", coordinates = { x = 256,  y = 500, } },
      { map = "ghz1Map", coordinates = { x = 2048, y = 100, } },
      { map = "ghz1Map", coordinates = { x = 8192, y = 800, } },
    },
  },

}
