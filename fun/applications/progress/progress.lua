
--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 550, 900
local COLOR_IMAGE   = love.graphics.newImage("fun/resources/images/sonicAdventure.png")
local OUTLINE_IMAGE = love.graphics.newImage("fun/resources/images/sonicAdventureTransparent.png")

local LAYER_SPEED   = 120
local zSpeed        = 0
local z             = 0

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Sonic Progress")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
    love.graphics.draw(COLOR_IMAGE,   -z, -z, 0, 0.5 - (z / 1500), 0.5 - (z / 1500))
    love.graphics.setColor(1, 1, 1, 1 - (z / 150))
    love.graphics.rectangle("fill",   0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(OUTLINE_IMAGE, z, z, 0, 0.5 + (z / 1500), 0.5 + (z / 1500))
end

function love.keypressed(key)
    if key == "right" then
        zSpeed = LAYER_SPEED
    elseif key == "left" then
        zSpeed = -LAYER_SPEED
    end
end

function love.keyreleased(key)
    zSpeed = 0
end

function love.update(dt)
    z = math.min(150, math.max(0, z + (zSpeed * dt)))
end


