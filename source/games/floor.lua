import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "games/staticSprite.lua"

class('Floor').extends(StaticSprite)

function Floor:init(x, y, zIndex, shadow)
    local imageIndex = shadow and 48 or 49
    UnbreakableBlock.super.init(self, x, y, imageIndex, zIndex, false)
end
