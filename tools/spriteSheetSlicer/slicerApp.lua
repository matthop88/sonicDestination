--[[

--------------------------------------------------------------
--                  Functional Specifications               --
--------------------------------------------------------------

     * Program "automagically" finds borders of all sprites in image
     * Border is drawn when mouse moves over a sprite
     * When a sprite is clicked on, x, y, width and height are
       displayed on screen.

     * Program displays "gallery" of images at bottom of screen.
     * Images in gallery are thumbnails that scale a bit when mouseover occurs.
     * Images belong to an animation sequence and are specified in an external data file.
     * When gallery image is pressed, an editor "window" pops up, with blown-up image
     * Images can be cycled through to test out animation
     * X and Y offsets are displayed in text fields
     * When mouse is inside a text field, up and down arrows increment and decrement values
     * Full stats of rects can be printed to console.

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

local MARGIN_BACKGROUND_COLOR = { r = 0.15, g = 0.40, b = 0.10, a = 1 }
local SPRITE_BACKGROUND_COLOR = { r = 0.00, g = 0.00, b = 0.00, a = 0 }

local WINDOW_WIDTH, WINDOW_HEIGHT = 1024, 768

local slicer      = require "tools/spriteSheetSlicer/slicingEngine"
local currentRect = require "tools/spriteSheetSlicer/smartRect"

local imgPath     = "resources/images/sadSlicer.png"

local gallerySpriteRects = {
    { x =  41, y = 347, w = 26, h = 39 },
    { x = 102, y = 346, w = 29, h = 40 },
    { x = 162, y = 345, w = 39, h = 40 },
    { x = 224, y = 346, w = 39, h = 39 },
    { x = 293, y = 347, w = 26, h = 39 },
    { x = 355, y = 346, w = 28, h = 40 },
    { x = 412, y = 345, w = 40, h = 38 },
    { x = 476, y = 346, w = 39, h = 39 },
}

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

if __SLICER_FILE ~= nil then
    imgPath = "resources/images/spriteSheets/" .. __SLICER_FILE .. ".png"
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
    drawGallery()
end

function drawGallery()
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", 0, 684, 1024, 86)
    love.graphics.setColor(1, 1, 1)

    love.graphics.setLineWidth(2)
    for x = 8, 1024, 73 do
        love.graphics.rectangle("line", x, 696, 60, 60)
    end

    for n, spriteRect in ipairs(gallerySpriteRects) do
        love.graphics.draw(getImageViewer():getImage(),
                love.graphics.newQuad(spriteRect.x, spriteRect.y, spriteRect.w, spriteRect.h,
                getImageViewer():getImageWidth(), getImageViewer():getImageHeight()),
                (n * 73) - 65 + ((60 - spriteRect.w) / 2), 706, 0, 1, 1)
    end
                    
                
end

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("imageViewer",
    {
        imagePath      = imgPath,
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

slicer:start({
    imageViewer          = getImageViewer(),
    marginBGColor        = MARGIN_BACKGROUND_COLOR,
    spriteBGColor        = SPRITE_BACKGROUND_COLOR,
    callbackWhenComplete = onSlicingCompletion
})

