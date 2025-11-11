local RING_PULSE       = 1
local TIME             = 0

local FONT             = love.graphics.newFont(16)
local ROTATION         = 0

FONTS = {
    get = function(self, size)
        local fontSize = math.floor(size)
        if self[fontSize] == nil and fontSize >= 1 then
            self[fontSize] = love.graphics.newFont(fontSize)
        end
        return self[fontSize]
    end,
}

local isInsideRing = function(ring, px, py)
    return px >= ring.x - 8 and px < ring.x + 8 and py >= ring.y - 8 and py < ring.y + 8
end

local drawRingDetails = function(ring, imageViewer)
    local mx, my = love.mouse.getPosition()
    love.graphics.setColor(1, 1, 1, 0.7)
    love.graphics.rectangle("fill", imageViewer:pageToScreenRect(ring.x - 10, ring.y - 10, 20, 20))
    love.graphics.setColor(0, 0, 0, 0.5)
    local scale = imageViewer:getScale()
    love.graphics.rectangle("fill", mx + (16 * scale), my + (16 * scale), 100 * scale, 20 * scale)
    love.graphics.setColor(1, 1, 1)
    FONT = FONTS:get(16 * scale)
    love.graphics.setFont(FONT)
    love.graphics.printf("" .. ring.x .. ", " .. ring.y, mx + (16 * scale), my + (16 * scale), 100 * scale, "center")
end

local drawRingBorder = function(ring, imageViewer)
    love.graphics.setColor(1, 1, 0, (1 - ring.alpha) * 0.7)
    love.graphics.setLineWidth(1 * imageViewer:getScale())
    local px, py = imageViewer:imageToScreenCoordinates(ring.x, ring.y)
    love.graphics.push()
    love.graphics.translate(px, py)
    love.graphics.rotate(ROTATION)
    love.graphics.translate(-px, -py)
    love.graphics.rectangle("line", imageViewer:pageToScreenRect(ring.x - 9, ring.y - 9, 17, 17))
    love.graphics.pop()
end

local drawRing = function(ring, imageViewer, ringInfo)
    if ring.alpha ~= nil then
        local ringScale = math.max(1, (ring.alpha * ring.alpha * 400))
        local deltaX = ring.deltaX * (ringScale - 1)
        local deltaY = ring.deltaY * (ringScale - 1)
        drawRingBorder(ring, imageViewer)
        if not ring.erased then
            local x, y = imageViewer:imageToScreenCoordinates(ring.x + deltaX, ring.y + deltaY)
            local scale = imageViewer:getScale() * ringScale
            ringInfo:draw(x, y, scale, { 1, 0, 0, RING_PULSE * (1 - ring.alpha) *  (1 - ring.alpha) * 0.7})
        end
    end
end

local updateRing = function(ring, dt)
	if ring.alpha == nil then 
        ring.alpha  = 1
        ring.speed  = math.random(2, 6) / 3
        ring.deltaX = math.random(-20, 20)
        ring.deltaY = math.random(-6, 6)
    else           
        ring.alpha  = math.max(0, ring.alpha - (ring.speed * dt))
    end
end

local drawRings = function(self, imageViewer, ringInfo)
	for _, ring in ipairs(self) do
		drawRing(ring, imageViewer, ringInfo)
	end
    for _, ring in ipairs(self) do
        if ring.alpha == 0 and isInsideRing(ring, imageViewer:screenToImageCoordinates(love.mouse.getPosition())) then
            drawRingDetails(ring, imageViewer)
        end
    end
end

local updateRings = function(self, dt, isComplete)
	for _, ring in ipairs(self) do
		updateRing(ring, dt)
	end

    ROTATION = ROTATION + (math.pi / 90)

	if isComplete then
        RING_PULSE = 0.5 + math.sin(TIME * 5) * 0.5
        TIME = TIME + dt
    end
end

local findSelectedRing = function(self, imageViewer)
    for _, ring in ipairs(self) do
        if isInsideRing(ring, imageViewer:screenToImageCoordinates(love.mouse.getPosition())) then
            return ring
        end
    end
end

return {
	upgradeRingList = function(self, ringList)
		ringList.draw = drawRings
		ringList.update = updateRings
        ringList.findSelected = findSelectedRing
	end,
}
