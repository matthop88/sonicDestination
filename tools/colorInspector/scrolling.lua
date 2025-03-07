local SCROLL_SPEED   = 400
local xSpeed, ySpeed = 0,   0

function handleScrollKeypressed(key)
    if     key == "left"  then scrollLeft()
    elseif key == "right" then scrollRight()
    elseif key == "up"    then scrollUp()
    elseif key == "down"  then scrollDown()
    end
end

function handleScrollKeyreleased(key)
    if     key == "left"  then stopScrollingLeft()
    elseif key == "right" then stopScrollingRight()
    elseif key == "up"    then stopScrollingUp()
    elseif key == "down"  then stopScrollingDown()
    end
end
    
function updateScrolling(dt)
	x = x + xSpeed * dt * scale
	y = y + ySpeed * dt * scale
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
