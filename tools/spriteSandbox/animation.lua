return {
	create = function(self, animationData)
		return {
			data = animationData,

			isDefault    = function(self)    return self.data.isDefault    end,

			getFPS       = function(self)    return self.data.fps          end,

			size         = function(self)    return #self.data             end,
			get          = function(self, n) return self.data[n]           end,
			frames       = function(self)    return self.data              end,

			width        = function(self)    return self.data.w            end,
			height       = function(self)    return self.data.h            end,

			offsetX      = function(self)    return self.data.offset.x     end,
			offsetY      = function(self)    return self.data.offset.y     end,
			
			reps         = function(self)    return self.data.reps         end,
			synchronized = function(self)    return self.data.synchronized end,
			foreground   = function(self)    return self.data.foreground   end,
		}
	end,
}
