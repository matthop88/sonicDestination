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
    local oldScale = getScale()
    adjustScaleGeometrically(scaleDelta * dt)
    local newScale = getScale()
    
    moveImage((px / newScale) - (px / oldScale), (py / newScale) - (py / oldScale)) 
end

function zoomIn()             scaleDelta =  ZOOM_SPEED           end
function zoomOut()            scaleDelta = -ZOOM_SPEED           end

function stopZoomingIn()      scaleDelta =  0                    end
function stopZoomingOut()     scaleDelta =  0                    end
