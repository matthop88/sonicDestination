--[[

--------------------------------------------------------------
--                  Functional Specifications               --
--------------------------------------------------------------

[ ] 1. Program "automagically" finds borders of all sprites in image
[ ] 2. Border is drawn when mouse moves over a sprite
[ ] 3. When a sprite is clicked on, x, y, width and height are
       displayed on screen.

					Border Finding Algorithm
					------------------------
	   Scan each line of image.
	   Look for edges of borders.

	   Left edge:  Transition from Margin Background color
								to Sprite Background color.

	   Right edge: Transition from Sprite Background color
								to Margin Background color.

	   Same transition applies to top and bottom edges.

	   Border information is captured in a data structure.

						  Prerequisites
						  -------------
	   [ ] Identify Margin Background color
	   [ ] Identify Sprite Background color

--]]

--------------------------------------------------------------
--                      Global Variables                    --
--------------------------------------------------------------

-- ...
-- ...
-- ...

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

-- ...
-- ...
-- ...

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- Function Name: love.draw()
-- Called By:	  LOVE2D application, every single frame
--------------------------------------------------------------
function love.draw()
	-- All drawing code goes here
end

-- ...
-- ...

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

-- ...
-- ...
-- ...
