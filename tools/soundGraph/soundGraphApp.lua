--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1280, 512

local SOUND_DATA = require("tools/soundGraph/soundData")

local SOUND_OBJECT = require("tools/soundGraph/soundObject"):create(
	"game/resources/sounds/" .. (__SOUND_FILE or "sonicCDJump.mp3")
):init()

local SOUND_VIEW = require("tools/soundGraph/soundView"):create {
	soundObject = SOUND_OBJECT,
	samplingRate = 64,
	marginLeft = 100,
}

local function loadSound(soundKey)
	local soundInfo = SOUND_DATA[soundKey]
	if not soundInfo then
		print("Error: Sound key not found: " .. soundKey)
		return
	end
	
	local soundPath = "game/resources/sounds/" .. soundInfo.filename
	print("Loading sound: " .. soundPath)
	
	-- Create new sound object and view
	SOUND_OBJECT = require("tools/soundGraph/soundObject"):create(soundPath):init()
	SOUND_VIEW = require("tools/soundGraph/soundView"):create {
		soundObject = SOUND_OBJECT,
		samplingRate = 64,
		marginLeft = 100,
	}
	SOUND_VIEW:analyzeData()
end

-- Get list of sound names from soundData
local soundItems = {}
local labelToKeyMap = {}  -- Map from display label to original key
for soundKey, soundInfo in pairs(SOUND_DATA) do
	table.insert(soundItems, soundInfo.label)
	labelToKeyMap[soundInfo.label] = soundKey
end
table.sort(soundItems)

local LIST = require("tools/lib/guiList/list"):create {
	x = 100,
	y = 100,
	width = 300,
	height = 400,
	fontSize = 16,
	items = soundItems,
	onItemSelected = function(listOrPane, label, index)
		local soundKey = labelToKeyMap[label]
		print("Selected: " .. label .. " (key: " .. soundKey .. ", index " .. index .. ")")
		loadSound(soundKey)
		listOrPane:setVisible(false)
	end,
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
    local handled = LIST:handleMousePressed(mx, my)
    if not handled then
        print(SOUND_VIEW:getSampleXFromMouseX())
    end
end

function love.mousereleased()
    LIST:handleMouseReleased()
end

function love.keypressed(key)
    if key == "space" then
        local samplePosition = SOUND_VIEW:getSampleXFromMouseX()
        SOUND_OBJECT:playFromSample(samplePosition)
    elseif key == "L" then
        LIST:setVisible(true)
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

