import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "Plugins/AnimatedSprite/AnimatedSprite.lua"
import "games/utils.lua"

class('BreakableBlock').extends(AnimatedSprite)

function BreakableBlock:init(i, j, zIndex)
    BreakableBlock.super.init(self, envImagetable)
    local speedAnimation = 10
    self:addState('block', 44, 44, { tickStep = speedAnimation }).asDefault()
    self:addState('destructionAnimation', 45, 47, { tickStep = speedAnimation })
    local x, y = getPositionAtCoordonate(i,j)
    self:moveTo(x, y)
    self:setZIndex(zIndex)
    self:playAnimation()
    self:setCollideRect(0,0,16,16)
    self:setGroups({collisionGroup.block})
end

function BreakableBlock:update()
    BreakableBlock.super.update(self)
end
