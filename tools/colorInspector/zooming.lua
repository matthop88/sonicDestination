local ZOOM_SPEED = 2
local scaleDelta = 0

function updateZooming(dt)
    if scaleDelta ~= 0 then
        zoomFromCoordinates(dt, love.mouse.getPosition())
        keepImageInBounds()
    end
end

function zoomFromCoordinates(dt, mx, my)
    local oldScale = scale
        
    scale = oldScale + scaleDelta * dt * oldScale
            
    x = x - (mx / oldScale) + (mx / scale)
    y = y - (my / oldScale) + (my / scale)
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
