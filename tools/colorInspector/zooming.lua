local ZOOM_SPEED = 2
local scaleDelta = 0

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
    
function updateZooming(dt)
    if scaleDelta ~= 0 then
        zoomFromCoordinates(dt, love.mouse.getPosition())
    end
end

function zoomFromCoordinates(dt, px, py)
    local oldScale = scale
        
    scale = oldScale + scaleDelta * dt * oldScale
            
    moveImage((px / scale) - (px / oldScale), (py / scale) - (py / oldScale)) 
end

function zoomIn()             scaleDelta =  ZOOM_SPEED           end
function zoomOut()            scaleDelta = -ZOOM_SPEED           end

function stopZoomingIn()      scaleDelta =  0                    end
function stopZoomingOut()     scaleDelta =  0                    end
