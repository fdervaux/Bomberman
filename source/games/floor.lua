class('Floor').extends(StaticSprite)

function Floor:init(x, y, zIndex, shadow)
    local imageIndex = shadow and 48 or 49
    UnbreakableBlock.super.init(self, x, y, imageIndex, zIndex, false)
end
