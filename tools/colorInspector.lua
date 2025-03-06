--------------------------------------------------------------
--                 Functional Specifications                --
--------------------------------------------------------------

--[[
                       Short Description
                       -----------------
          An image of choice is drawn to the screen.
          Clicking on any pixel of the image prints
          an RGB description of the color both to
          the screen and to the text console.

                           Features
                           --------
       [.] Image can be scrolled using the up, down,
           left and right arrow keys.
       [ ] Image can be zoomed in using the 'z' key
           and zoomed out using the 'a' key
       [ ] Clicking on any pixel of the image prints
           an RGB description of the color both to
           the screen and to the text console.

--]]

--------------------------------------------------------------
--                      Global Variables                    --
--------------------------------------------------------------

IMAGE = love.graphics.newImage("resources/images/spriteSheets/sonic1.png")
        -- https://www.spriters-resource.com/sega_genesis_32x/sonicth1/sheet/21628/

x = 0
y = 0

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Color Inspector")
love.window.setMode(800, 600, { display = 2 })
-- ...

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- Function Name: love.draw()
-- Called By:     LOVE2D application, every single frame
--------------------------------------------------------------
function love.draw()
	love.graphics.draw(IMAGE, x, y)
end

-- Function Name: love.keypressed()
-- Called By:     LOVE2D application, when any key is pressed
-- Parameters:    key - text value of key pressed by the user
--------------------------------------------------------------
function love.keypressed(key)
	-- Code to handle key press event goes here
	print(key)

	-- To Scroll Left:  Increase X
	-- To Scroll Right: Decrease X

    if key == "left" then
        x = x + 100
	end

	if key == "right" then
    	x = x - 100
	end
end

-- ...

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

-- ...
-- ...
-- ...

