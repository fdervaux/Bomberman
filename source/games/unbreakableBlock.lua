import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "games/staticSprite.lua"

class('UnbreakableBlock').extends(StaticSprite)

function UnbreakableBlock:init(i, j, zIndex)
    local imageIndex = 43
    UnbreakableBlock.super.init(self, i, j, imageIndex, zIndex, true)
    self:setGroups({collisionGroup.block})
end