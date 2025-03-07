IMAGES = {
	love.graphics.newImage("resources/images/Questions.png"),
	love.graphics.newImage("resources/images/PresentationProgress.png"),
	love.graphics.newImage("resources/images/TimeOverTime.png"),
	love.graphics.newImage("resources/images/PieChart.png"),
	love.graphics.newImage("resources/images/SpendingChart.png"),
	love.graphics.newImage("resources/images/SonicCover.png"),
}

transitions = {
	"FADE",
	"FADE",
	"SCROLL",
	"SCROLL",
	"SCROLL",
	"SCROLL",
}

imageIndex     = 0
prevImageIndex = 0

transition     = 0

love.window.setTitle("A Very Important Business Presentation")
love.window.setMode(1024, 768)

function love.draw()
	if transitions[imageIndex] == "FADE" or imageIndex == 0 then
		local oldAlpha = 1 - (transition / 200)
		local newAlpha = transition / 200

		if prevImageIndex > 0 then
			drawImage(prevImageIndex, 0, 0, oldAlpha)
		end
		if imageIndex > 0 then
			drawImage(imageIndex, 0, 0, newAlpha)
		end
	else
		local yDelta = math.max(((100 - transition) / 100) * love.graphics:getHeight(), 0)

		if prevImageIndex > 0 then
			drawImage(prevImageIndex, 0, yDelta - love.graphics:getHeight(), 1)
		end
		if imageIndex > 0 then
			drawImage(imageIndex, 0, yDelta, 1)
		end
	end
end

function drawImage(index, xDelta, yDelta, alpha)
	local image = IMAGES[index]
	local scale = math.min(love.graphics:getWidth() / image:getWidth(), love.graphics:getHeight() / image:getHeight())
	
	local width  = image:getWidth()  * scale
	local height = image:getHeight() * scale

	local x = (love.graphics:getWidth()  - width)  / 2
	local y = (love.graphics:getHeight() - height) / 2

	love.graphics.setColor(1, 1, 1, alpha)
	love.graphics.draw(image, x + xDelta, y + yDelta, 0, scale, scale)
end
	
function love.keypressed(key)
	if key == "space" then
		prevImageIndex = imageIndex
		imageIndex = imageIndex + 1
		if imageIndex > #IMAGES then
			imageIndex = 0
		end
		transition = 0
	end
end	

function love.update(dt)
	transition = math.min(200, transition + (200 * dt))
end

	
	
