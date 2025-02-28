local ZOOM_SPEED = 2
local scaleDelta = 0

function updateZooming(dt)
    if scaleDelta ~= 0 then
        --[[
            Adjust x and y of image so that we are zooming in at point
            the mouse is at
        --]]
            
        -- Given: mx, my => mouse position
        local mx, my = love.mouse.getPosition()
        
        -- 1. Translate x, y so that point at (mx, my) is at upper left corner of screen
        local leftX = 0
        local topY  = 0

        local dx = (mx - leftX) / scale
        local dy = (my -  topY) / scale

        x = x - dx
        y = y - dy
        
        -- 2. Scale in same manner as before
        scale = scale + scaleDelta * dt * scale
            
        -- 3. Translate x, y back so that point at upper left corner of screen becomes (mx, my)
        local leftX = 0
        local topY  = 0

        local dx = (mx - leftX) / scale
        local dy = (my -  topY) / scale

        x = x + dx
        y = y + dy
        
        keepImageInBounds()
    end
end

function love.mousepressed(mx, my)
    -- Translate x, y so that point at (mx, my) is at upper left corner of screen
    local leftX = 0
    local topY  = 0

    local dx = (mx - leftX) / scale
    local dy = (my -  topY) / scale

    x = x - dx
    y = y - dy
end

function love.mousereleased(mx, my)
    -- Translate x, y so that point at upper left corner of screen moves to (mx, my)
    local leftX = 0
    local topY  = 0

    local dx = (mx - leftX) / scale
    local dy = (my -  topY) / scale

    x = x + dx
    y = y + dy
end

function handleZoomKeypressed(key)
    if     key == "z" then zoomIn()
    elseif key == "a" then zoomOut()
    end
end

function handleZoomKeyreleased(key)
    if     key == "z" then stopZoomingIn()
    elseif key == "a" then stopZoomingOut()
    end
end

function zoomIn()         scaleDelta =  ZOOM_SPEED end
function zoomOut()        scaleDelta = -ZOOM_SPEED end

function stopZoomingIn()  scaleDelta =  0          end
function stopZoomingOut() scaleDelta =  0          end
