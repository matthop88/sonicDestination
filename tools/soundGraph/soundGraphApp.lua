--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1280, 512

local SOUND_OBJECT = nil
local SOUND_VIEW = require("tools/soundGraph/soundView"):create {
	soundObject = nil,
	samplingRate = 64,
	marginLeft = 100,
}

local SOUND_LIST  -- Forward declaration

local function loadSound(soundKey)
	local soundInfo = SOUND_LIST:getSoundInfo(soundKey)
	if not soundInfo then
		print("Error: Sound key not found: " .. soundKey)
		return
	end
	
	-- Reset progress bar before loading
	getProgressBar():refresh()
	
	local basePath = SOUND_LIST:isMusicTrack(soundKey) and "game/resources/music/" or "game/resources/sounds/"
	local soundPath = basePath .. soundInfo.filename
	print("Loading sound: " .. soundPath)
	
	-- Create new sound object and refresh view
	local success, result = pcall(function()
		return require("tools/soundGraph/soundObject"):create(soundPath):init()
	end)
	
	if not success then
		print("Error loading sound file: " .. result)
		print("The file may be corrupted or empty.")
		return
	end
	
	SOUND_OBJECT = result
	print("Sound loaded, starting analysis...")
	SOUND_VIEW:refresh(SOUND_OBJECT, 64, 100)
	print("Analysis coroutine created")
end

SOUND_LIST = require("tools/soundGraph/soundList"):create {
	x = (WINDOW_WIDTH - 400) / 2,
	y = (WINDOW_HEIGHT - 400) / 2,
	width = 400,
	height = 400,
	fontSize = 28,
	scrollSpeed = 1200,
	onSoundSelected = function(soundKey, label, index)
		print("Selected: " .. label .. " (key: " .. soundKey .. ", index " .. index .. ")")
		loadSound(soundKey)
	end,
}

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    if SOUND_VIEW then
        SOUND_VIEW:draw()
    end
    SOUND_LIST:draw()
end

function love.update(dt)
    SOUND_LIST:update(dt)
    if SOUND_VIEW then
        SOUND_VIEW:update(dt)
        if not SOUND_VIEW:isAnalysisComplete() then
            local progress = SOUND_VIEW:getProgress()
            setProgressBarText(string.format("Loading Sound Data... %.0f%%", progress * 100))
        end
    end
end

function love.mousepressed(mx, my)
    local handled = SOUND_LIST:handleMousePressed(mx, my)
    if not handled and SOUND_VIEW and SOUND_OBJECT then
        print(SOUND_VIEW:getSampleXFromMouseX())
    end
end

function love.mousereleased()
    SOUND_LIST:handleMouseReleased()
end

function love.keypressed(key)
    if key == "space" and SOUND_VIEW and SOUND_OBJECT then
        if SOUND_OBJECT:isPlaying() then
            SOUND_OBJECT:pause()
        else
            local samplePosition = SOUND_VIEW:getSampleXFromMouseX()
            SOUND_OBJECT:playFromSample(samplePosition)
        end
    elseif key == "shiftleft" and SOUND_OBJECT then
        SOUND_OBJECT:jumpToBeginning()
        SOUND_VIEW:refreshView()
    elseif key == "shiftright" and SOUND_OBJECT then
        SOUND_OBJECT:jumpToEnd()
        SOUND_VIEW:refreshView()
    elseif key == "L" then
        SOUND_LIST:setVisible(true)
    elseif key == "F" and SOUND_VIEW then
        local enabled = SOUND_VIEW:toggleFollowPlaybackCursor()
        print("Follow playback cursor: " .. (enabled and "ENABLED" or "DISABLED"))
    end
end

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Sound Graph Application")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

-- Start with list visible
SOUND_LIST:setVisible(true)

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("zooming",    { imageViewer = SOUND_VIEW })
    :add("scrolling",  { imageViewer = SOUND_VIEW, scrollY = false, scrollSpeed = 48000 })
    :add("progressBar",
    {
        message       = "Loading Sound Data...",
        callback      = function() return SOUND_VIEW:getProgress() end,
        setTextFnName = "setProgressBarText",
        accessorFnName = "getProgressBar",
    })

