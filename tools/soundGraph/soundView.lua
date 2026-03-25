return {
	create = function(self, params)
		local WINDOW_WIDTH = params.windowWidth or 1280
		local WAVEFORM_HEIGHT = params.waveformHeight or 512
		local MARKER_PANE_HEIGHT = params.markerPaneHeight or 64
		local INFO_PANE_HEIGHT = params.infoPaneHeight or 200
		
		return ({
			soundObject = params.soundObject,
			soundModel = nil,
			samplingRate = params.samplingRate or 64,
			marginLeft = params.marginLeft or 100,
			waveformHeight = WAVEFORM_HEIGHT,
			waveformPane = nil,
			markerPane = nil,
			infoPane = nil,
			timelineScrubber = nil,

			refresh = function(self, soundObject, samplingRate, marginLeft)
				self.soundObject = soundObject
				self.samplingRate = samplingRate or self.samplingRate
				self.marginLeft = marginLeft or self.marginLeft
				self.soundModel = require("tools/soundGraph/soundModel"):create(soundObject)
				self.soundModel:startAnalysis()
				
				-- Update child components
				if self.waveformPane then
					self.waveformPane:refresh(soundObject, samplingRate, marginLeft)
				end
				if self.markerPane then
					self.markerPane:setSoundObject(soundObject)
				end
				if self.infoPane then
					self.infoPane:setSoundObject(soundObject)
				end
				if self.timelineScrubber then
					self.timelineScrubber:setSoundObject(soundObject)
				end
			end,
			
			getProgress = function(self)
				return self.soundModel and self.soundModel:getProgress() or 1
			end,
			
			isAnalysisComplete = function(self)
				if not self.soundModel then return true end
				return self.soundModel:isAnalysisComplete()
			end,
	
			draw = function(self)
				-- Draw child components
				if self.waveformPane then
					self.waveformPane:draw()
				end
				if self.markerPane then
					self.markerPane:draw()
				end
				if self.infoPane then
					self.infoPane:draw()
				end
				if self.timelineScrubber then
					self.timelineScrubber:draw()
				end
			end,
			
			update = function(self, dt)
				-- Resume analysis coroutine if it exists
				if self.soundModel then
					self.soundModel:updateAnalysis()
					
					-- Initialize scale after analysis completes
					if self.soundModel:isAnalysisComplete() then
						local minOptimumScale = self.soundModel:getMinOptimumScale()
						if self.waveformPane then
							self.waveformPane:initializeScale(minOptimumScale)
						end
						
					-- Update child components with sound model after analysis completes
					if self.markerPane and self.markerPane.soundModel ~= self.soundModel then
						self.markerPane:setSoundModel(self.soundModel)
					end
					if self.infoPane and self.infoPane.soundModel ~= self.soundModel then
						self.infoPane:setSoundModel(self.soundModel)
					end
					if self.waveformPane and self.waveformPane.soundModel ~= self.soundModel then
						self.waveformPane:setSoundModel(self.soundModel)
					end
					if self.timelineScrubber and self.timelineScrubber.soundModel ~= self.soundModel then
						self.timelineScrubber:setSoundModel(self.soundModel)
					end
				end
				end
				
				-- Update current sample
				if self.waveformPane then
					self.waveformPane:updateCurrentSample()
				end
				
				if self.waveformPane and self.waveformPane.followPlaybackCursor and self.soundObject and self.soundObject:isPlaying() then
					self.waveformPane:syncViewWithCurrentSample()
				end
				
				-- Update child components
				if self.markerPane then
					self.markerPane:update(dt)
				end
				if self.timelineScrubber then
					self.timelineScrubber:update(dt)
				end
			end,
			
			refreshView = function(self)
				if self.waveformPane then
					self.waveformPane:refreshView()
				end
			end,
			
			toggleFollowPlaybackCursor = function(self)
				if self.waveformPane then
					return self.waveformPane:toggleFollowPlaybackCursor()
				end
				return false
			end,
			
			getSampleXFromMouseX = function(self)
				return self.waveformPane and self.waveformPane:getSampleXFromMouseX() or 0
			end,
		    
		    handleMousePressed = function(self, mx, my)
		    	if self.timelineScrubber and self.timelineScrubber:handleMousePressed(mx, my) then
		    		return true
		    	end
		    	if self.markerPane and self.markerPane:handleMousePressed(mx, my) then
		    		return true
		    	end
		    	return false
		    end,
		    
		    handleMouseReleased = function(self)
		    	if self.timelineScrubber then
		    		self.timelineScrubber:handleMouseReleased()
		    	end
		    	if self.markerPane then
		    		self.markerPane:handleMouseReleased()
		    	end
		    end,
		    
		    getStartMarkerSample = function(self)
		    	return self.soundObject and self.soundObject:getStartPoint() or 0
		    end,
		    
		    init = function(self)
		    	-- Create waveform pane
		    	self.waveformPane = require("tools/soundGraph/waveformPane"):create {
		    		x = 0,
		    		y = 0,
		    		width = params.windowWidth or 1280,
		    		height = params.waveformHeight or 512,
		    		samplingRate = params.samplingRate or 64,
		    		marginLeft = params.marginLeft or 100,
		    	}
		    	
		    	-- Create marker pane
		    	self.markerPane = require("tools/soundGraph/markerPane"):create {
		    		x = 0,
		    		y = self.waveformHeight,
		    		width = params.windowWidth or 1280,
		    		height = params.markerPaneHeight or 64,
		    		soundView = self.waveformPane,
		    		onMarkerChanged = function()
		    		end,
		    	}
		    	
		    	-- Create info pane
		    	self.infoPane = require("tools/soundGraph/infoPane"):create {
		    		x = 0,
		    		y = self.waveformHeight + (params.markerPaneHeight or 64),
		    		width = params.windowWidth or 1280,
		    		height = params.infoPaneHeight or 200,
		    	}
		    	
		    	-- Create timeline scrubber
		    	local infoPaneY = self.waveformHeight + (params.markerPaneHeight or 64)
		    	self.timelineScrubber = require("tools/soundGraph/timelineScrubber"):create {
		    		x = 0,
		    		y = infoPaneY + 170,
		    		width = params.windowWidth or 1280,
		    		margin = 40,
		    		thumbWidth = 12,
		    		thumbHeight = 20,
		    		onPositionChanged = function()
		    			self:refreshView()
		    		end,
		    	}
		    	
		    	return self
		    end,
		}):init()
	end,
}
