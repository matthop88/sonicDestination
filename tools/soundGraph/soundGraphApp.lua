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

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    SOUND_VIEW:draw()
end

function love.mousepressed(mx, my)
    print(SOUND_VIEW:getSampleXFromMouseX())
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

