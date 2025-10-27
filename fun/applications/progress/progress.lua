
--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 550, 900
local COLOR_IMAGE   = love.graphics.newImage("fun/resources/images/sonicAdventure.png")
local OUTLINE_IMAGE = love.graphics.newImage("fun/resources/images/sonicAdventureTransparent.png")

local FONT             = love.graphics.newFont(30)

local LAYER_SPEED      = 120
local FILL_SPEED       = 120
local ySpeed           = 0
local y                = 0
local zSpeed           = 0
local z                = 0
local targetedProgress = tonumber(__PROGRESS) or 50.0
local targetedY        = nil

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
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(COLOR_IMAGE,   -z, -z, 0, 0.5 - (z / 1500), 0.5 - (z / 1500))
    love.graphics.setColor(1, 1, 1, 1 - (z / 150))
    love.graphics.rectangle("fill",   0, y, WINDOW_WIDTH, WINDOW_HEIGHT)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(OUTLINE_IMAGE, z, z, 0, 0.5 + (z / 1500), 0.5 + (z / 1500))

    drawProgress()
end

function love.keypressed(key)
    if     key == "right" then zSpeed =  LAYER_SPEED
    elseif key == "left"  then zSpeed = -LAYER_SPEED
    elseif key == "up"    then ySpeed = -FILL_SPEED
    elseif key == "down"  then ySpeed =  FILL_SPEED
    elseif key == "space" then markTargetedProgress()
    end
end

function love.keyreleased(key)
    zSpeed = 0
    ySpeed = 0
end

function love.update(dt)
    if targetedY ~= nil and zSpeed == 0 then updateBasedUponTargetedY(dt)
    else                                    updateBasedUponManualControls(dt) end
end

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

function updateBasedUponTargetedY(dt)
    ySpeed = -FILL_SPEED
    y = math.max(targetedY, y + (ySpeed * dt))
end

function updateBasedUponManualControls(dt)
    z = math.min(150, math.max(0, z + (zSpeed * dt)))
    y = math.min(0, math.max(-900, y + (ySpeed * dt))) 
end

function printProgress()
    local progress = math.max(0, -(y + 35) / 865) * 100
    print(string.format("PROGRESS: %.2f%%", progress))
end

function markTargetedProgress()
    targetedY = -((targetedProgress / 100 * 865) + 35)
end

function drawProgress()
    local offsetY = -math.min(0, 882 + y)
    local progress = math.max(0, -(y + 35) / 865) * 100
    love.graphics.setFont(FONT)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 400, 882 + y + offsetY, 150, 40)
    love.graphics.setLineWidth(3)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", 400, 882 + y + offsetY, 150, 40)
    love.graphics.setColor(1, 1, 0)
    love.graphics.printf(string.format("%.2f%%", progress), 0, 885 + y + offsetY, 540, "right")
end
