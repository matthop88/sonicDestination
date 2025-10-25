
--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 550, 900
local COLOR_IMAGE   = love.graphics.newImage("fun/resources/images/sonicAdventure.png")
local OUTLINE_IMAGE = love.graphics.newImage("fun/resources/images/sonicAdventureTransparent.png")

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Sonic Progress")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill",   0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
    love.graphics.draw(COLOR_IMAGE,   0, 0, 0, 0.5, 0.5)
    love.graphics.draw(OUTLINE_IMAGE, 0, 0, 0, 0.5, 0.5)
end


