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

local LIST = require("tools/soundGraph/list"):create {
	x = 20,
	y = 20,
	width = 200,
	fontSize = 24,
	items = { "Item 1", "Item 2", "Item 3", "Item 4", "Item 5" }
}

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    SOUND_VIEW:draw()
    LIST:draw()
end

function love.update(dt)
    LIST:update(dt)
end

function love.mousepressed(mx, my)
    local item, index = LIST:handleClick(mx, my)
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

