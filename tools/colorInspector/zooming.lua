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
        --[[
            Adjust x and y of image so that we are zooming in at point
            the mouse is at
        --]]

        scale = scale + scaleDelta * dt * scale
    end
end

function zoomIn()             scaleDelta =  ZOOM_SPEED           end
function zoomOut()            scaleDelta = -ZOOM_SPEED           end

function stopZoomingIn()      scaleDelta =  0                    end
function stopZoomingOut()     scaleDelta =  0                    end
