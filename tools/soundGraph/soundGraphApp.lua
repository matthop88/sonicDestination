--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1280, 776
local WAVEFORM_HEIGHT = 512
local MARKER_PANE_HEIGHT = 64
local INFO_PANE_HEIGHT = 200

local SOUND_OBJECT = nil
local SOUND_VIEW = require("tools/soundGraph/soundView"):create {
	soundObject = nil,
	samplingRate = 64,
	marginLeft = 100,
}

local MARKER_PANE = require("tools/soundGraph/markerPane"):create {
	x = 0,
	y = WAVEFORM_HEIGHT,
	width = WINDOW_WIDTH,
	height = MARKER_PANE_HEIGHT,
	soundView = SOUND_VIEW,
	onMarkerChanged = function()
		-- Future: handle marker position changes
		print("Start marker moved")
	end,
}

local INFO_PANE = require("tools/soundGraph/infoPane"):create {
	x = 0,
	y = WAVEFORM_HEIGHT + MARKER_PANE_HEIGHT,
	width = WINDOW_WIDTH,
	height = INFO_PANE_HEIGHT,
	onPositionChanged = function()
		if SOUND_VIEW then
			SOUND_VIEW:refreshView()
		end
	end,
}

local SOUND_LIST = require("tools/soundGraph/soundList"):create {
	x = (WINDOW_WIDTH - 400) / 2,
	y = (WINDOW_HEIGHT - 400) / 2,
	width = 400,
	height = 400,
	fontSize = 28,
	scrollSpeed = 1200,
	onSoundLoaded = function(soundObject)
		-- Reset progress bar before loading
		getProgressBar():refresh()
		
		SOUND_OBJECT = soundObject
		print("Analysis coroutine created")
		SOUND_VIEW:refresh(SOUND_OBJECT, 64, 100)
		INFO_PANE:setSoundObject(SOUND_OBJECT)
		MARKER_PANE:setSoundObject(SOUND_OBJECT)
	end,
}

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    if SOUND_VIEW then
        SOUND_VIEW:draw()
    end
    MARKER_PANE:draw()
    INFO_PANE:draw()
    SOUND_LIST:draw()
end

function love.update(dt)
    SOUND_LIST:update(dt)
    MARKER_PANE:update(dt)
    INFO_PANE:update(dt)
    if SOUND_VIEW then
        SOUND_VIEW:update(dt)
        if not SOUND_VIEW:isAnalysisComplete() then
            local progress = SOUND_VIEW:getProgress()
            setProgressBarText(string.format("Loading Sound Data... %.0f%%", progress * 100))
        else
            -- Update panes with sound model once analysis is complete
            if SOUND_VIEW.soundModel and not INFO_PANE.soundModel then
                INFO_PANE:setSoundModel(SOUND_VIEW.soundModel)
                MARKER_PANE:setSoundModel(SOUND_VIEW.soundModel)
            end
        end
    end
    
    -- Handle thumb dragging
    if INFO_PANE.timelineScrubber and INFO_PANE.timelineScrubber.isDragging then
        local mx, my = love.mouse.getPosition()
        INFO_PANE:handleMouseDragged(mx, my)
    end
    
    -- Handle marker dragging
    if MARKER_PANE.isDraggingStart then
        local mx, my = love.mouse.getPosition()
        MARKER_PANE:handleMouseDragged(mx, my)
    end
end

function love.mousepressed(mx, my)
    local handled = SOUND_LIST:handleMousePressed(mx, my)
    if not handled then
        handled = INFO_PANE:handleMousePressed(mx, my)
    end
    if not handled then
        handled = MARKER_PANE:handleMousePressed(mx, my)
    end
    if not handled and SOUND_VIEW and SOUND_OBJECT then
        print(SOUND_VIEW:getSampleXFromMouseX())
    end
end

function love.mousereleased()
    SOUND_LIST:handleMouseReleased()
    INFO_PANE:handleMouseReleased()
    MARKER_PANE:handleMouseReleased()
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

