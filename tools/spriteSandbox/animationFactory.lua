local IMAGE_LOADER = require("tools/lib/util/imageLoader")

return {
	create = function(self, pathPrefix, objectName, animationName)
        local object    = require("tools/spriteSandbox/data/objects/" .. pathPrefix .. objectName)
        local animation = object.animations[animationName]
        local image     = IMAGE_LOADER:loadImage("resources/images/spriteSheets/" .. object.imageName .. ".png")
        
        return require("tools/spriteSandbox/animation"):create(animationName, animation, image)
    end,
}
