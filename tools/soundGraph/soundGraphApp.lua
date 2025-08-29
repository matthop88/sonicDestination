--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1280, 512
local SOUND_DATA = love.sound.newSoundData("game/resources/sounds/" .. (__SOUND_FILE or "sonicCDJump.mp3"))

local SAMPLING_RATE = 64
local MARGIN_LEFT   = 100
local NUM_SAMPLES   = SOUND_DATA:getSampleCount()

local sampleData = {}

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    for k, v in ipairs(sampleData) do
        love.graphics.setColor(1, 1, 1)
        love.graphics.line(MARGIN_LEFT + k, 256 - v.max, MARGIN_LEFT + k, 256 - v.min)
    end

    love.graphics.setColor(0, 1, 0)
    local mx, my = love.mouse.getPosition()

    mx = getConstrainedMouseX()
    love.graphics.line(mx, 0, mx, 512)
end

function love.mousepressed(mx, my)
    print(getSampleXFromMouseX())
end

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

function getSampleXFromMouseX()
    local mx = (getConstrainedMouseX() - MARGIN_LEFT) + 1
    return math.min(mx * SAMPLING_RATE, NUM_SAMPLES - 1)
end

function getConstrainedMouseX()
    local mx, _ = love.mouse.getPosition()
    return math.min(math.max(mx, MARGIN_LEFT), MARGIN_LEFT + #sampleData)
end

function analyzeData()
    local min, max     = 0, 0
    local indexInChunk = 0

    local NUM_SAMPLES = SOUND_DATA:getSampleCount()

    for i = 0, NUM_SAMPLES - 1 do
        local currentSample = SOUND_DATA:getSample(i) * 256
        min = math.min(currentSample, min)
        max = math.max(currentSample, max)
        indexInChunk = indexInChunk + 1
        if indexInChunk >= SAMPLING_RATE or indexInChunk >= NUM_SAMPLES - 1 then
            table.insert(sampleData, { min = min, max = max })
            indexInChunk, min, max = 0, 0, 0
        end
    end
end

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Sound Graph Application")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

analyzeData()

