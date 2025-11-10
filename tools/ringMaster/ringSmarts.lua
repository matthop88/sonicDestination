local RING_PULSE       = 1
local TIME             = 0

local drawRing = function(ring, imageViewer, ringInfo)
	if ring.alpha ~= nil then
        local ringScale = math.max(1, (ring.alpha * ring.alpha * 400))
        local deltaX = ring.deltaX * (ringScale - 1)
        local deltaY = ring.deltaY * (ringScale - 1)

        local x, y = imageViewer:imageToScreenCoordinates(ring.x + 8 - (8 * ringScale) + deltaX, ring.y + 8 - (8 * ringScale) + deltaY)
        local scale = imageViewer:getScale() * ringScale
        ringInfo:draw(x, y, scale, { 1, 0, 0, RING_PULSE * (1 - ring.alpha) *  (1 - ring.alpha) * 0.7})
        love.graphics.setColor(1, 1, 0, (1 - ring.alpha) * 0.7)
        love.graphics.setLineWidth(1 * imageViewer:getScale())
        love.graphics.rectangle("line", imageViewer:pageToScreenRect(ring.x, ring.y, 16, 16))
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
end

local updateRings = function(self, dt, isComplete)
	for _, ring in ipairs(self) do
		updateRing(ring, dt)
	end

	if isComplete then
        RING_PULSE = 0.5 + math.sin(TIME * 5) * 0.5
        TIME = TIME + dt
    end
end

return {
	upgradeRingList = function(self, ringList)
		print("Update Rings FN: ", updateRings)
		print("RingList: ", ringList)
		ringList.draw = drawRings
		ringList.update = updateRings
	end,
}
