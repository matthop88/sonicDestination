require "tools/colorInspector/doubleTap"

local SCROLL_SPEED   = 400

local xSpeed, ySpeed = 0,   0
local dashing        = false

function handleScrollKeypressed(key)
    dashing = isDoubleTap(key)
    
    if     key == "left"  then scrollLeft()
    elseif key == "right" then scrollRight()
    elseif key == "up"    then scrollUp()
    elseif key == "down"  then scrollDown()
    end

    setLastKeypressed(key)
end

function handleScrollKeyreleased(key)
    if     key == "left"  then stopScrollingLeft()
    elseif key == "right" then stopScrollingRight()
    elseif key == "up"    then stopScrollingUp()
    elseif key == "down"  then stopScrollingDown()
    end
end
    
function updateScrolling(dt)
    x = x + xSpeed * dt
    y = y + ySpeed * dt
end

function scrollLeft()         xSpeed =   calculateScrollSpeed()  end
function scrollRight()        xSpeed = -(calculateScrollSpeed()) end  
function scrollUp()           ySpeed =   calculateScrollSpeed()  end
function scrollDown()         ySpeed = -(calculateScrollSpeed()) end
  
function stopScrollingLeft()  xSpeed = math.min(0, xSpeed)       end
function stopScrollingRight() xSpeed = math.max(0, xSpeed)       end
function stopScrollingUp()    ySpeed = math.min(0, ySpeed)       end
function stopScrollingDown()  ySpeed = math.max(0, ySpeed)       end

function calculateScrollSpeed()
    if dashing then return SCROLL_SPEED * 2
    else            return SCROLL_SPEED
    end
end

function isMotionless()
    return not isWithinDoubleTapThreshold() and xSpeed == 0 and ySpeed == 0
end

