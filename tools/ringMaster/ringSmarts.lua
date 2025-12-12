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

local drawRingDetails = function(ring, imageViewer, ringInfo)
    local mx, my = love.mouse.getPosition()
    love.graphics.setColor(1, 1, 1, 0.7)
    love.graphics.rectangle("fill", imageViewer:pageToScreenRect(ring.x - ((ringInfo.width / 2) + 2), ring.y - ((ringInfo.height / 2) + 2), ringInfo.width + 4, ringInfo.height + 4))
    love.graphics.setColor(0, 0, 0, 0.5)
    local scale = imageViewer:getScale()
    love.graphics.rectangle("fill", mx + (ringInfo.width * scale), my + (ringInfo.height * scale), 100 * scale, 20 * scale)
    love.graphics.setColor(1, 1, 1)
    FONT = FONTS:get(16 * scale)
    love.graphics.setFont(FONT)
    love.graphics.printf("" .. ring.x .. ", " .. ring.y, mx + (ringInfo.width * scale), my + (ringInfo.height * scale), 100 * scale, "center")
end

local drawRingBorder = function(ring, imageViewer, ringInfo)
    love.graphics.setColor(1, 1, 0, (1 - ring.alpha) * 0.7)
    love.graphics.setLineWidth(1 * imageViewer:getScale())
    local px, py = imageViewer:imageToScreenCoordinates(ring.x, ring.y)
    love.graphics.push()
    love.graphics.translate(px, py)
    love.graphics.rotate(ROTATION)
    love.graphics.translate(-px, -py)
    love.graphics.rectangle("line", imageViewer:pageToScreenRect(ring.x - ((ringInfo.width / 2) + 1), ring.y - ((ringInfo.height / 2) + 1), ringInfo.width + 1, ringInfo.height + 1))
    love.graphics.pop()
end

local drawRing = function(ring, imageViewer, ringInfo)
    if ring.alpha ~= nil then
        local ringScale = math.max(1, (ring.alpha * ring.alpha * 400))
        local deltaX = ring.deltaX * (ringScale - 1)
        local deltaY = ring.deltaY * (ringScale - 1)
        drawRingBorder(ring, imageViewer, ringInfo)
        if not ring.erased then
            local x, y = imageViewer:imageToScreenCoordinates(ring.x + deltaX, ring.y + deltaY)
            local scale = imageViewer:getScale() * ringScale
            ringInfo:draw(x, y, scale, { 1, 0, 0, RING_PULSE * (1 - ring.alpha) *  (1 - ring.alpha) * 0.7})
        end
    end
end

local updateRing = function(ring, dt)
    ring.detailsTimer = ring.detailsTimer or 0
    ring.detailsTimer = math.max(0, ring.detailsTimer - (60 * dt))

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
        if ring.alpha == 0 and ring.detailsTimer > 0 then
            drawRingDetails(ring, imageViewer, ringInfo)
        end
    end
end

local updateRings = function(self, dt, imageViewer, isComplete)
    for _, ring in ipairs(self) do
		updateRing(ring, dt)
        if isInsideRing(ring, imageViewer:screenToImageCoordinates(love.mouse.getPosition())) then
            for _, ring2 in ipairs(self) do ring2.detailsTimer = 0 end
            ring.detailsTimer = 20
        end
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
