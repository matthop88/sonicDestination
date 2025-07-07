--[[

--------------------------------------------------------------
--                  Functional Specifications               --
--------------------------------------------------------------

     * Program "automagically" finds borders of all sprites in image
     * Border is drawn when mouse moves over a sprite
     * When a sprite is clicked on, x, y, width and height are
       displayed on screen.

   [X] Program displays "gallery" of images at bottom of screen.
   [X] Images in gallery are thumbnails that scale a bit when mouseover occurs.
   [X] Images belong to an animation sequence and are specified in an external data file.
   [ ] When gallery image is pressed, an editor "window" pops up, with blown-up image
   [ ] Images can be cycled through to test out animation
   [ ] X and Y offsets are displayed in text fields
   [ ] When mouse is inside a text field, up and down arrows increment and decrement values
   [ ] Full stats of rects can be printed to console.

--]]

--------------------------------------------------------------
--                       Local Variables                    --
--------------------------------------------------------------

local ASCII_ART = [[
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

local WINDOW_WIDTH, WINDOW_HEIGHT = 1024, 768

local slicer      = require "tools/spriteSheetSlicer/slicingEngine"
local currentRect = require "tools/spriteSheetSlicer/smartRect"

local imgPath     = "resources/images/sadSlicer.png"

local sheetInfo   = { spriteRects = {}, MARGIN_BG_COLOR = { r = 0, g = 0, b = 0, a = 1 }, SPRITE_BG_COLOR = { r = 0, g = 0, b = 0, a = 0 } }
local gallery

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

if __SLICER_FILE ~= nil then
    sheetInfo = require("tools/spriteSheetSlicer/data/" .. __SLICER_FILE)
    imgPath = sheetInfo.imagePath
end

love.window.setTitle("Sprite Sheet Slicer - SLICING...")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.update(dt)
    slicer:update(dt)
    local imageX, imageY = getImageViewer():screenToImageCoordinates(love.mouse.getPosition())
    if not currentRect:containsPt(imageX, imageY) then
        currentRect:initFromRect(slicer:findEnclosingRect(imageX, imageY))
    end
    gallery:update(dt)
end

function love.mousepressed(mx, my)
    if currentRect:isValid() then
        currentRect:select(true)
        printToReadout(currentRect:toString())
    end
end

function love.mousereleased(mx, my)
    currentRect:select(false)
end

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

function getImageViewer()
    -- Overridden by imageViewer plugin
end

function onSlicingCompletion()
    love.window.setTitle("Sprite Sheet Slicer")
end

function drawOverlays()
    slicer:draw()
    currentRect:draw()
    gallery:draw()
end

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("imageViewer",
    {
        imagePath      = imgPath,
        pixelated      = true,
        accessorFnName = "getImageViewer"
    })
    :add("zooming",      { imageViewer = getImageViewer() })
    :add("scrolling",    { imageViewer = getImageViewer() })
    :add("drawingLayer", { drawingFn   = drawOverlays     })
    :add("readout",
    {
        printFnName    = "printToReadout",
        echoToConsole  = true,
    })

--------------------------------------------------------------
--             Static code - is executed last               --
--------------------------------------------------------------

gallery = require("tools/spriteSheetSlicer/gallery"):init(sheetInfo.spriteRects)

slicer:start({
    imageViewer          = getImageViewer(),
    marginBGColor        = sheetInfo.MARGIN_BG_COLOR,
    spriteBGColor        = sheetInfo.SPRITE_BG_COLOR,
    callbackWhenComplete = onSlicingCompletion
})

