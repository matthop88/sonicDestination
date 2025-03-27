--[[

--------------------------------------------------------------
--                  Functional Specifications               --
--------------------------------------------------------------

[X] 1. Program "automagically" finds borders of all sprites in image
[X] 2. Border is drawn when mouse moves over a sprite
[X] 3. When a sprite is clicked on, x, y, width and height are
       displayed on screen.

--]]

--------------------------------------------------------------
--                      Global Variables                    --
--------------------------------------------------------------

ASCII_ART = [[
               eeeeeeeeeeee                                     
       ZeeeeeeeeZeeeee2222eeeeeeZ                               
   ÕëëëëëëëëZeeeeeeeeZZZZZ222222eeeeZ      ÕëëÕ                 
    ÕëëëëëëëëëëëëëZeeZëëooZZ2nn22222eeeeZÕëëëëÕ                 
        ÕëëëëëëëëëëZZZee¦¦nnee2nnnn2222eeZëëëëÕ                 
             ÕëëÕëëëëë2n¦››¦ee22oonnnnn2eeëëëëÕ                 
              ZZëëZZëë2n¦¦¦¦¦¿22o¿¿¿¿onnn2eeëëë                 
          ZeeZeeZZeZëë2nnnnnnnoooooooo¿onnn2eee                 
         ZeeeeZZëëZeeeee2nnnoonnnnnnnnoonnn2eee                 
     eeeeeeeeZëëëëZeee2nnn2nnnnn    ¿onnoonnn2eee               
   eeeeeeeeeeZëëëëZeee2nnnnn2no¿      ¿onnnnnno¿o               
 eeeeZëëëëëëZZëëëëZeeeee2nnnnno¿      ÕNZe2nn2NÆÆ               
ëëëëëëëëëëëëëëëëëëëëZeee2nn2nno¿      ÕÆÆNZe22NÆÆ               
ëëëëëëëëëÕëëëëëëëëëëZeeeeeee2nno      ÕÆÆNnnÕNÆÆÆ               
          ÕëëÕëëëëëëëëZeeeeeeeeeo¿    ÕÆÆÕ››ÕNe22               
            eZZëëëëëëëëZZe22¿¿¿¿22¦   onnn¦¦eZZZno              
        eeeZeeeZëëëëëëëëeeno    on¦¦      ¿o2eNNe22             
      eZeeeZZZZZëëëëëëëë2n¦›››››        ›››¦ÕÆÆÆÆÆÆ             
     eeeZZZZëëëëëëëëëëëë2n¦¦››››››››››¦¦¦¦¦¦¦                   
     ZZZëëëëëëëëëëëëëÕÕÕëë2n¦››››››››¦nnn2ëÕÕ                   
   eeZëëëëëëëëëëëëëëëÕÆÆÕëëë2nnnnnnnn2ëÕÕÕÕ                     
             ëëëëëëëëëëÕÆÆÆÆÕëëëZZëÕÕÕÕÕÕ                       
                 Õëëëë¿¦¦¦¦¦¦¦ee2n¦¦¦¦n2ëÕÕ                     
               ÕëZ¿¦¦¿onnnnn2e2n¦¦››››¦¦n22                     
             ÕëZo¿ooonZZZZZZZenn¦››››››¦nnn                     
             ëëZ¦¦n2ZZëëëëëëZennoo¦››¦onZëë                     
            ëëÕëo¿¦¦oo22oo2eee22nn¿¿¿oeZÕNëZ                    
           Õëëëëen    ¦¦  ¦¿eZZe222222ëÕNÕZeno                  
           ëëëëëÕZ› oo     ›ZëZeZZZZZZÕÕZZnoooo                 
           ÕëëëëëënneenoooonZëZZëÕNNÕÕÆÆëZnnooo                 
           ëëÕÕ    nnnooooonn2eeeÕëëëÕÆÆÆNëZZ                   
                   ÆÆNnoonëë2nn  ëëëëëë                         
                         ëëë2nn  ëëëëëë                         
                       ëëë222    ÕëëëÕÕ                         
                       Õëë2nn    ëëëëëë                         
                   ooo¦¦››     ZZZ2nnnooo                       
                   oooo¿¿¦›››››ZZZeeeenoooo                     
                  ÆNe2oooo222n  22ZZZZnoeee                     
                 ÆÆÆÕë22n2ZZe2› onZZëZ22ëë2ooo                  
                ÆÆNNÕÕÕëZZ¿¦››onnnZZÕÕÕÕëZ2222ZÕÕÕÕÕ            
               ÆÆÆÕÕÕÕÕëno¿¿eZZZZZZZZZZZÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ      
               ÆÆÆÕÕÕÕÕënnZZZZZZZZZZZZZZZZZZZZNNNNÕÕÕÕÕÕÕÕÕ     
               ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ   
]]

WINDOW_WIDTH  = 1024
WINDOW_HEIGHT = 768

currentRect   = require("tools/spriteSheetSlicer/smartRect")

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

love.mousepressed = function(mx, my)
    currentRect:printUsing(printToReadout)
end

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

drawCurrentRect = function()
    local imageX, imageY = getImageViewer():screenToImageCoordinates(love.mouse:getPosition())
    
    currentRect:calculateUsing(imageX, imageY, findEnclosingRect)
    currentRect:draw()
end

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("imageViewer",  
    { 
        imagePath    = "resources/images/spriteSheets/sonic1.png",
        accessFnName = "getImageViewer" 
    })
    :add("zooming",      { imageViewer  = getImageViewer() })
    :add("scrolling",    { imageViewer  = getImageViewer() })
    :add("drawingLayer", { drawingFn    = drawCurrentRect })
    :add("readout",      { printFnName  = "printToReadout" })


--------------------------------------------------------------
--                Static code - is executed last            --
--------------------------------------------------------------

love.window.setTitle("Spritesheet Slicer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

require("tools/spriteSheetSlicer/slicingEngine"):slice()
