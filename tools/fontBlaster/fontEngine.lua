local loadDataFilesFromDirectory = function(directoryName)
	local files = {}

	local directoryItems = love.filesystem.getDirectoryItems(directoryName)
    
    for _, v in ipairs(directoryItems) do
        if string.sub(v, -3, -1) == "lua" then
            local filename = string.sub(v, 1, -5)
            files[filename] = require(directoryName .. "/" .. filename)
        end
    end

    return files
end

return {
	create = function(self)
		return ({
			fontBlocks = {},

			init = function(self)
				local fonts = loadDataFilesFromDirectory(relativePath("resources/fonts"))
				self.fonts = {}

				for k, v in pairs(fonts) do
					local image = love.graphics.newImage(relativePath("resources/images/spriteSheets/" .. v.image))
    				image:setFilter("nearest", "nearest")
					self.fonts[k] = { image = image, data = {}, spaceWidth = v.spaceWidth }
					for _, glyph in ipairs(v.data) do
						local value = {}
						local q = glyph.value.quad
						local quad = love.graphics.newQuad(q.x, q.y, q.w, q.h, image:getWidth(), image:getHeight())
						value.quad = quad
						value.w = q.w
						value.h = q.h
						self.fonts[k].data[glyph.key] = value
					end
				end

				return self
			end,

			draw = function(self, graphics, id, fontData, x, y)
				local fontBlock = self.fontBlocks[id]
				if not fontBlock then
					print("Creating font block...")
					local font = self.fonts[fontData.fontName]
					fontBlock = require("tools/fontBlaster/fontBlock"):create { font = font, fontData = fontData, x = x, y = y }
					self.fontBlocks[id] = fontBlock
				end
				fontBlock:draw(graphics)
			end,

			createFontObject = function(self, fontData)
				local font = self.fonts[fontData.fontName]
				local obj = { image = font.image, glyphs = {} }
				for _, key in ipairs(fontData.keys) do 
					local glyph = {}
					local f = font.data[key]
					if f == nil then
						glyph.w = font.spaceWidth or 16
					else
						glyph.w = f.w + 1
						glyph.quad = f.quad
					end
					table.insert(obj.glyphs, glyph)
				end
				return obj
			end,

		}):init()
	end,
}
