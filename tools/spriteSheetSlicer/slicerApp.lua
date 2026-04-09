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
   [X] When gallery image is pressed, an editor "window" pops up, with blown-up image
   [X] Images can be cycled through to test out animation
   [X] X and Y offsets are displayed in text fields
   [X] When mouse is inside a text field, up and down arrows increment and decrement values
   [X] Full stats of rects can be printed to console.

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
local currentRect = require("tools/spriteSheetSlicer/smartRect"):create()
local animRects   = {
    selectedIndex = 0,
    
    initFromAnimations = function(self, animations)
        for k, v in pairs(animations) do
            if v.rect then
                local smartRect = require("tools/spriteSheetSlicer/smartRect"):create():initFromRect(v.rect)
                smartRect.sprites = v.sprites
                smartRect.fps     = v.fps or 1
                table.insert(self, smartRect)
            end
        end
    end,
    
    draw = function(self)
        for _, animRect in ipairs(self) do animRect:draw() end
    end,

    updateBasedOnPt = function(self, px, py)
        for _, animRect in ipairs(self) do
            animRect:setVisible(animRect:containsPt(px, py))
        end
    end,

    select = function(self, px, py)
        self.selectedIndex = 0
        
        for n, animRect in ipairs(self) do
            if animRect:containsPt(px, py) then
                self.selectedIndex = n
            end
        end
    end,

    getSelectedSprites = function(self)
        if self.selectedIndex ~= 0 then
            if self[self.selectedIndex] == nil then return nil
            else                                    return self[self.selectedIndex].sprites end
        end
    end,

    getSelectedFPS = function(self)
        if self.selectedIndex ~= 0 then
            if self[self.selectedIndex] == nil then return nil
            else                                    return self[self.selectedIndex].fps end
        end
    end,

    next = function(self)
        self.selectedIndex = math.min(#self, self.selectedIndex + 1)
    end,

    prev = function(self)
        self.selectedIndex = math.max(1, self.selectedIndex - 1)
    end,
}
            
local imgPath     = "resources/images/sadSlicer.png"
local imgName     = __PARAMS["image"]

local sheetInfo   = { spriteRects = {}, animations = {}, MARGIN_BG_COLOR = { r = 0.15, g = 0.40, b = 0.10, a = 1 }, SPRITE_BG_COLOR = { r = 0.05, g = 0.28, b = 0.03, a = 1 } }
local gallery

local CURRENT_STATE

local STATE = {
    MARGIN_BG_COLOR = {
        execute = function(self)
            printToReadout("Please select the Margin Background Color.")
        end,
        collect = function(self, r, g, b, a)
            sheetInfo.MARGIN_BG_COLOR = { r = r, g = g, b = b, a = a }
        end,
        mousePressed = function(self, mx, my)
            self:collect(selectColorMousePressed(mx, my))
            CURRENT_STATE:doNext()
        end,
    },
    SPRITE_BG_COLOR = {
        execute = function(self)
            printToReadout("Please select the Sprite Background Color.")
        end,
        collect = function(self, r, g, b, a)
            sheetInfo.SPRITE_BG_COLOR = { r = r, g = g, b = b, a = a }
        end,
        mousePressed = function(self, mx, my)
            self:collect(selectColorMousePressed(mx, my))
            CURRENT_STATE:doNext()
        end,
    },
    READY_TO_SLICE  = {
        execute = function(self)
            printToReadout("Press any key to begin slicing.")
        end,
        keyPressed = function(self, key)
            CURRENT_STATE:doNext()
        end,
    },
    POST_SLICE      = {
        execute = function(self)
            slicer:start({
                imageViewer          = getImageViewer(),
                marginBGColor        = sheetInfo.MARGIN_BG_COLOR,
                spriteBGColor        = sheetInfo.SPRITE_BG_COLOR,
                callbackWhenComplete = onSlicingCompletion
            })
        end,
    }
}

CURRENT_STATE = {
    states = {
        STATE.MARGIN_BG_COLOR, STATE.SPRITE_BG_COLOR, STATE.READY_TO_SLICE, STATE.POST_SLICE,
    },
    currentIndex = 1,
    get = function(self)
        return self.states[self.currentIndex]
    end,
    next = function(self)
        self.currentIndex = self.currentIndex + 1
        if self.currentIndex > #self.states then self.currentIndex = 1 end
    end,
    prev = function(self)
        self.currentIndex = self.currentIndex - 1
        if self.currentIndex < 1 then self.currentIndex = #self.states end
    end,
    equals = function(self, state)
        return self:get() == state
    end,
    set = function(self, state)
        for i = 1, #self.states do
            self.currentIndex = i
            if self:equals(state) then
                return
            end
        end
    end,
    execute = function(self)
        self:get():execute()
    end,
    doNext = function(self)
        self:next()
        self:execute()
    end,
    collect = function(self, r, g, b, a)
        if self:get().collect then self:get():collect(r, g, b, a) end
    end,
    mousePressed = function(self, mx, my)
        if self:get().mousePressed then 
            self:get():mousePressed(mx, my)
            return true
        end
    end,
    keyPressed = function(self, key)
        if self:get().keyPressed then
            self:get():keyPressed(key)
            return true
        end
    end,
}

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------


if imgName ~= nil then
    imgPath = __PARAMS["path"]
    if not imgPath then
        sheetInfo = require("tools/spriteSheetSlicer/data/" .. imgName)
        sheetInfo.spriteRects = sheetInfo.spriteRects or {}
        sheetInfo.animations  = sheetInfo.animations  or {}
        sheetInfo.MARGIN_BG_COLOR.a = sheetInfo.MARGIN_BG_COLOR.a or 1
        sheetInfo.SPRITE_BG_COLOR.a = sheetInfo.SPRITE_BG_COLOR.a or 1
        CURRENT_STATE:set(STATE.READY_TO_SLICE)
        imgPath = sheetInfo.imagePath
    else
        imgPath = imgPath .. imgName .. ".png"
    end
end

love.window.setTitle("Sprite Sheet Slicer - SLICING...")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.update(dt)
    slicer:update(dt)
    local imageX, imageY = getImageViewer():screenToImageCoordinates(love.mouse.getPosition())
    if not currentRect:containsPt(imageX, imageY) or love.keyboard.isDown("lshift", "rshift") then
        currentRect:initFromRect(slicer:findEnclosingRect(imageX, imageY))
    end
    animRects:updateBasedOnPt(imageX, imageY)
    gallery:update(dt)
end

function love.keypressed(key)
    if not CURRENT_STATE:keyPressed(key) then
        if not gallery:keypressed(key) then
            if     key == "up"   then
                animRects:next()
                refreshGallery()
            elseif key == "down" then
                animRects:prev()
                refreshGallery()
            end
        end
    end
end

function love.keyreleased(key)
    gallery:keyreleased(key)
end

function love.mousepressed(mx, my)
    if not CURRENT_STATE:mousePressed(mx, my) then
        if not gallery:mousepressed(mx, my) and currentRect:isValid() then
            currentRect:select(true)
            animRects:select(mx, my)
            refreshGallery()
            printToReadout(currentRect:toString())
        end
    end
end

function love.mousereleased(mx, my)
    currentRect:select(false)
end

function selectColorMousePressed(mx, my)
    local imageX, imageY = getImageViewer():screenToImageCoordinates(mx, my)
    local r, g, b, a     = getImageViewer():getPagePixelAt(imageX, imageY)
    return r, g, b, a
end

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

function refreshGallery()
    gallery:refresh(animRects:getSelectedSprites(), animRects:getSelectedFPS())
    gallery:updateEditor()
end

function getImageViewer()
    -- Overridden by imageViewer plugin
end

function initAnimationInfo()
    animRects:initFromAnimations(sheetInfo.animations)
end

function onSlicingCompletion()
    love.window.setTitle("Sprite Sheet Slicer")
end

function drawOverlays()
    slicer:draw()
    animRects:draw()
    currentRect:draw()
    gallery:draw()
end

function onColorSelected(color)
    local r, g, b = unpack(color)
    print(string.format("{ r = %.2f, g = %.2f, b = %.2f }", r, g, b))
    --printToReadout(string.format("R = %s, G = %s, B = %s", love.math.colorToBytes(r, g, b)))
end

function showStateInfo()
    if CURRENT_STATE:equals(STATE.MARGIN_BG_COLOR) then
        printToReadout("Please select the Margin Background Color.")
    elseif CURRENT_STATE:equals(STATE.SPRITE_BG_COLOR) then
        printToReadout("Please select the Sprite Background Color.")
    elseif CURRENT_STATE:equals(STATE.READY_TO_SLICE) then
        printToReadout("Press any key to begin slicing.")
    end
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
    :add("doubleClick",
    {
        accessorFnName = "getDoubleClick",
    })
    :add("modKeyEnabler")
    :add("scrolling",    { 
        imageViewer = getImageViewer(),
        leftKey     = "shiftleft",
        rightKey    = "shiftright",
        upKey       = "shiftup",
        downKey     = "shiftdown",
    })
    :add("zooming",      { imageViewer = getImageViewer() })
    :add("drawingLayer", { drawingFn   = drawOverlays     })
    :add("readout",
    {
        printFnName    = "printToReadout",
        echoToConsole  = true,
    })
    :add("questionBox",
    {   x = 974, destX = 62, w = 900,
        useDoubleClick = true,
        getDoubleClickFn = getDoubleClick,
        lines = {
            tabSize = 500,
            { "Shift-Arrow Keys:",                   "Scroll Image"                },
            { "z/a:",                                "Zoom in/out"                 },
            "",
            { "Click on Sprite:",                    "Show coordinates and size",  },
            { "Click on Sprite Group:",              "Open Gallery"                },
            { "Click on Gallery thumbnail:",         "Open Editor"                 },
            "",
            { "In Editor, right / left arrow keys:", "Iterate through frames"      },
            { "In Editor, up / down arrow keys:",    "Iterate through animations"  },
            { "In Editor, pressing 't':",            "Toggle Sprite Transparency"  },  
            { "On offset fields, up/down arrows:",   "Modify Sprite offsets"       },
            "",
            { "Option-A:",                           "Show Animation in real time" },
            { "On FPS field, up/down arrows:",       "Modify FPS"                  },
        },
    })
    :add("timedFunctions",
    {
        {   secondsWait = 1, 
            callback = function() 
                CURRENT_STATE:execute()
            end,
        },
    })   

--------------------------------------------------------------
--             Static code - is executed last               --
--------------------------------------------------------------

initAnimationInfo()
gallery = require("tools/spriteSheetSlicer/gallery")


