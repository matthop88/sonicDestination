--------------------------------------------------------------
--                 Functional Specifications                --
--------------------------------------------------------------

--[[
     Short description:
        An image of choice is drawn to the screen.
        Can click on any pixel and set the pixel color to be
        transparent throughout the image.
        Changes can be saved or reverted.

     Features:
        [X] Image can be scrolled using the up, down,
            left and right arrow keys.
        [X] Image can be zoomed in using the 'z' key
            and zoomed out using the 'a' key
        [X] Clicking on any pixel of the image shows
            a filled-in rectangle of the color for verification purposes.
        [X] Once a color is selected, pressing 'space' will
            turn the selected color transparent.
        [X] Pressing 'escape' will revert the transparency.
        [X] Pressing 'return' will save the edited image to disk.
--]]

--------------------------------------------------------------
--                     Global Variables                     --
--------------------------------------------------------------

WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600
selectedColor               = nil
changesMade                 = false

imgPath                     = "resources/images/transparencySad.png"
imgName                     = __TRANSPARENCY_FILE

if imgName ~= nil then
    imgPath = "resources/images/spriteSheets/" .. imgName .. ".png"
end

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- Function Name: love.keypressed(key)
-- Called By:     LOVE2D application, when a key is pressed
--------------------------------------------------------------
love.keypressed = function(key)
    if     key == "space"  then makeSelectedColorTransparent()
    elseif key == "escape" then revertChanges()
    elseif key == "return" then saveChanges()
    end
end

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

onColorSelected = function(color)
    selectedColor = color
    printToReadout("Press 'space' to make the selected color transparent.")
end

makeSelectedColorTransparent = function()
    if selectedColor ~= nil then
        getImageViewer():editPixels(createTransparency)
        changesMade = true
        printToReadout("Press 'escape' to revert all changes, or 'return' to save.")
    end
end

createTransparency = function(x, y, r, g, b, a)
   if colorMatchesRGB(selectedColor, r, g, b) then return 0, 0, 0, 0
   else                                            return r, g, b, a
   end
end

colorMatchesRGB = function(color, r, g, b)
     return color ~= nil and color.r == r and color.g == g and color.b == b
end

revertChanges = function()
    if changesMade then
        getImageViewer():reload()
        changesMade = false
        selectedColor = nil
        printToReadout("Changes have been reverted.")
    end
end

saveChanges = function()
    if changesMade then
        if imgName == nil then printToReadout("Cannot save changes without valid file.")
        else                   doSaveChanges()
        end
    end
end

doSaveChanges = function()
    local fileData = getImageViewer():saveImage(imgName)
    changesMade = false
            
    printToReadout("Changes have been saved (" .. fileData:getSize() .. " bytes.)")
    print("Saved to " .. love.filesystem.getSaveDirectory())
end

ASCII_ART = [[
                                                                                                                    
                                         $$XXXxxxxxxxxXXX$$                                                         
                                    $XXxxx+++++xxXXXXXX$$&&                                                         
                                $$XX+x+x++x+xxXXXXX$$$$$&                                                           
                              $X+++x++++x++xXXXX$++XXX$                                                             
                           $Xx++x+++x+x++xXXX$xxXXXXXXX$                                                            
                         $X+++x++x+++++x+XXX+XXX++;+XXX$                                                            
                $$$$$$$$X+x++++x++x++x++XXxxXX++;::;XXX$XX$$$$$                                                     
               $X++XXXX+x++x+x+;+;;+;++x+xXX+++::::;XX$XXXXXXXXX$$                                                  
                $x++XXx++x++++;;+;;+;;++++++xxXX++:;XX$$$XXXXXXXXXXX$                                               
                $X++$x++++x++;+;;+;++xXXXXx++++xXXXXXX$$$$$$$$$$$$$$XX$  +;;.:;;++                                  
                $Xx$X++x+++x+;;+;;++XXXXxxXXx++++XXXXX$$$$$$$$$$$$$$$$$x:      :;;X                                 
                 $X+++x++x++;+;;+++XXX;;;;;;xx+x+xXXXXXX$$$$$$$$$$$$$$$;       .;;+X                   ++++++++     
                $x++x+++x+++;;+;++xX;;.      ;x+++XXXXXX$$$$$$$$$$$$$$+         ;;+x               ++;;       .;;+  
                $x+X;X+x+++;+;;+++XX;.;X+:   .x+x+XXXXXX$$$$$$$$$$$&&x.         ;;+x           +;;.            .;;X 
                $X+X;:x++++;+;;+xXx;. $&&$.   +x+XXXXXXXX$$$$$&&&   +;;         ;;+X        +;:.                ;;; 
                 $XX: :Xx++x++++XX;;  +&&&+   +XXXXXXXXXX$$$&&     +; ;:        ;;+X   +++;;                   ;;;+X
                  $xx   XXx+++xX+;:    X&&&;  +XXXXXXXXXX$$$      +:  ;;       .;;X++++;                      ;;;++X
                   $X;  :&&XXXX;:      .&&&X .XXXXXXXXXX$$$$$$$$ +;:  ;;.      ;;+++++;:                   ;;;;;;++X
                    $X:  +&&X.          ;$&+ +xxXXXXXXXX$$$$$$$$$X;  .;;X;  ::;;+X+++;;:     :;:::::::;;;;;;;;;;++X 
                     $+   +&&;              . ....XXXXX$$$$$$$$$$X;  ;;;++X++++XXx+++;;;;..;;;;;;;;;;;;;;;;;;++++X  
                       $xXx...             ::;;:::+XXX$$$$$$$$$$$X;  ;;;++++++XXX++++++;;;;;;;;;+++++++++++++++X    
                      &&&Xx;  &&::::::::::::$&X+::+X&$$$$$$$$$X;  +:;;;;;++++XXXXx+++++x++++++++++XXXXXXXX          
                       &&&&&&&&&+::::::::+&&$&x::+X&$$$$$$$$xX.  .+;;;;;+++X;..:;;Xx+XX++++xX                       
                          X++++++:::::$&&$X$$;:;X&$$$$XX+;::X;  :;+;;;;+xXx;     .;;xX++++++++X                     
                   XX+;;xX X$x++++++;;::::;;+x$$$$x+;:::::;x;;;;;;+++++++++;.       ;;++Xx+++++X                    
                 X++;;;;;;;;+ $$$$X++++++$$$+$X$$+++++++++++;;;;+X;;;;;++X++;         ;;;++++++X                    
                  $X$;;++;;&+$$$+:;+++++:::::+XX$$$$$$$$$$x++;;;X++++++X;;;X+;;        ;;;+++++X                    
                  X+++xXXXXXX $$;:::::::::::++XXX$$$$$$$$$  X+++X+++++X.   :X++;;:     ;;;;++++X                    
                   XX          $+::::::::::;+XXXX$$$$$$$$$   XXXX++++X;:     ;+++;;;;;;;;;+++++X                    
                                X+;::::::+++XXXX$$$$$$$$$$$     XXX+++X;;     ;;Xx+++++;+++++x                      
                                $X++++++++XXXXXX&&&&$$$$$$$      X;;;;+X+;;;;;;;;;++++XXXXX                         
                             $XxXX&$XXXXXXXXXX$&&    &&$$$$      X+;;;;;+X+;;;;;;;;++++x                            
                          XX+xx$$&&&&&&&&&$XX&&&$&     &$$       X++;;;;;;xx+++;;++++++X                            
                 X:  xXXX+xXX&           &$X$&  $$&               X++++;;;;;+X+++++++X                              
                X. &&$++xX$              &XX&    &$&                X+++++++++X                                     
              x : .&$XX$$&+         XXXX$X&&       &                  XX+++++X                                      
            $$$ ::   :;;::;&       &;&&$$&$                              XXX                                        
          $$$X$; :;;..:;++$      &&;;;$&&$X                                                                         
        +;:  XX$$;;;;XXX&&       &$&;X+;+XX                                                                         
      $$XXXX:  XX$$$&&&$&       &$$$$$&&&                                                                           
    $$XXXXXXX.  X$$$$&&         &$$$$$$$&                                                                           
   $$XXXXXXXX$:;+$$&&           &X+;;;++$                                                                           
 $$XXXXXXXX$$$+X$&              &+$XXX$$X                                                                           
$$$XXXX$$$$$$&                   &$XXXX$$                                                                           
 $$$$$$&&&&                      &$XXXXX$                                                                           
                                  &$XXX$$                                                                           
                                  &$XXX$                                                                            
                                    $$$                                                                             
]]

--------------------------------------------------------------
--                        Plugins                           --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("imageViewer",
    {
        imagePath       = imgPath,
        accessorFnName  = "getImageViewer",
        pixelated       = true,
    })
    :add("zooming",      { imageViewer = getImageViewer() })
    :add("scrolling",    { imageViewer = getImageViewer() })
    :add("selectColor", 
    {
        imageViewer     = getImageViewer(),
        onColorSelected = onColorSelected,
    })
    :add("readout",
    {
        fontSize        = 28,
        horizMargins    = 0,
        boxHeight       = 56,
        printFnName     = "printToReadout",
    })

--------------------------------------------------------------
--               Static code - is executed last             --
--------------------------------------------------------------

love.window.setTitle("Transparency Editor")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })
