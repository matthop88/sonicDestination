--[[

--------------------------------------------------------------
--                  Functional Specifications               --
--------------------------------------------------------------

[ ] 1. Program "automagically" finds borders of all sprites in image
[ ] 2. Border is drawn when mouse moves over a sprite
[ ] 3. When a sprite is clicked on, x, y, width and height are
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

MARGIN_BACKGROUND_COLOR = { r = 0.05, g = 0.28, b = 0.03 }
SPRITE_BACKGROUND_COLOR = { r = 0.26, g = 0.60, b = 0.19 }

SPRITE_RECTS            = require("tools/spriteSheetSlicer/spriteRects")

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Spritesheet Slicer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

love.mousepressed = function(mx, my)
    local imageX, imageY = getImageViewer():screenToImageCoordinates(mx, my)
    local rect = SPRITE_RECTS:findEnclosingRect(imageX, imageY)
    if rect ~= nil then
        getReadout():printMessage("{ x = " .. rect.x .. ", y = " .. rect.y .. ", w = " .. rect.w .. ", h = " .. rect.h .. " }")
    end
end

-- ...
-- ...

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

drawSlices = function()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(3 * getImageViewer():getScale())
    for _, rect in SPRITE_RECTS:elements() do
        love.graphics.rectangle("line", getImageViewer():imageToScreenRect(rect.x - 2, rect.y - 2, rect.w + 4, rect.h + 4))
    end
end

slice = function()
    local widthInPixels, heightInPixels = getImageViewer():getImageSize()    
        
    doSlicing(widthInPixels, heightInPixels)

    print(ASCII_ART)
end

doSlicing = function(pixWidth, pixHeight)
    for y = 0, pixHeight - 1 do
        for x = 0, pixWidth - 1 do
            doSlicingAt(x, y)
        end
    end
end

doSlicingAt = function(x, y)
    local pixelColor = getImageViewer():getPixelColorAt(x, y)
    processPixelAt(x, y, pixelColor)
end

createPixelProcessor = function()
    local prevColor = nil
    
    return function(x, y, thisColor)
        if x == 0 then prevColor = nil end
        
        if enteringLeftOfSprite(prevColor, thisColor) then
            addSpriteRect(x, y, thisColor)
        end
        prevColor = thisColor
    end
end

enteringLeftOfSprite = function(prevColor, thisColor)
    return  colorsMatch(prevColor, MARGIN_BACKGROUND_COLOR)
    and not colorsMatch(thisColor, MARGIN_BACKGROUND_COLOR)
end

addSpriteRect = function(x, y, thisColor)
    local spriteRect = SPRITE_RECTS:add({ x = x, y = y, w = 50, h = 1 })
    if colorsMatch(thisColor, SPRITE_BACKGROUND_COLOR) then
        SPRITE_RECTS:markAsValid(spriteRect)
    end
end

exitingRightOfSprite = function(prevColor, thisColor)
    return not colorsMatch(prevColor, MARGIN_BACKGROUND_COLOR)
           and colorsMatch(thisColor, MARGIN_BACKGROUND_COLOR)
end

processPixelAt = createPixelProcessor()

colorsMatch = function(c1, c2)
    return c1 ~= nil and c2 ~= nil
       and math.abs(c1.r - c2.r) < 0.005
       and math.abs(c1.g - c2.g) < 0.005 
       and math.abs(c1.b - c2.b) < 0.005
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
    :add("drawingLayer", { drawingFn    = drawSlices })
    :add("readout",      { accessFnName = "getReadout" })


--------------------------------------------------------------
--                Static code - is executed last            --
--------------------------------------------------------------

slice()

