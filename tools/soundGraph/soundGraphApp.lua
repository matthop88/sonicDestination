--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1280, 512

local SOUND_OBJECT = require("tools/soundGraph/soundObject"):create(
	"game/resources/sounds/" .. (__SOUND_FILE or "sonicCDJump.mp3")
):init()

local SOUND_VIEW = require("tools/soundGraph/soundView"):create {
	soundObject = SOUND_OBJECT,
	samplingRate = 64,
	marginLeft = 100,
}

local OVAL_ITEM = require("tools/soundGraph/ovalItem")
local RECTANGLE_ITEM = require("tools/soundGraph/rectangleItem")

local defaultHeight = love.graphics.getFont():getHeight() + 10

local LIST = require("tools/soundGraph/list"):create {
	x = 0,
	y = 0,
	width = 200,
	fontSize = 24,
	items = { 
		"Item 1", 
		OVAL_ITEM:create { color = { 1, 0, 0 } },
		"Item 2", 
		RECTANGLE_ITEM:create { color = { 0, 1, 0 }, height = defaultHeight / 2, notSelectable = true },
		"Item 3",
		OVAL_ITEM:create { color = { 0, 0, 1 }, height = defaultHeight * 2 },
		"Item 4",
		"Item 5",
		"Item 6",
		"Item 7",
		"Item 8",
		"Item 9",
		"Item 10",
	}
}

local SCROLL_PANE = require("tools/soundGraph/scrollPane"):create {
	x = 100,
	y = 100,
	width = 200,
	height = 400,
	list = LIST
}

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    SOUND_VIEW:draw()
    SCROLL_PANE:draw()
end

function love.update(dt)
    SCROLL_PANE:update(dt)
end

function love.mousepressed(mx, my)
    local item, index = SCROLL_PANE:handleClick(mx, my)
    if item then
        print("Selected: " .. item .. " (index " .. index .. ")")
    else
        print(SOUND_VIEW:getSampleXFromMouseX())
    end
end

function love.keypressed(key)
    if key == "space" then
        local samplePosition = SOUND_VIEW:getSampleXFromMouseX()
        SOUND_OBJECT:playFromSample(samplePosition)
    elseif key == "w" then
        SCROLL_PANE:scrollBy(10)
    elseif key == "s" then
        SCROLL_PANE:scrollBy(-10)
    end
end

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Sound Graph Application")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

SOUND_VIEW:analyzeData()

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("zooming",    { imageViewer = SOUND_VIEW })
    :add("scrolling",  { imageViewer = SOUND_VIEW, scrollY = false, scrollSpeed = 24000 })

