import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "libraries/animatedSprite/AnimatedSprite.lua"
import "games/utils.lua"

class('BreakableBlock').extends(AnimatedSprite)

function BreakableBlock:init(i, j, zIndex)
    BreakableBlock.super.init(self, envImagetable)
    local speedAnimation = 10
    self:addState('block', 44, 44, { tickStep = speedAnimation }).asDefault()
    self:addState('destructionAnimation', 1, 4, { tickStep = speedAnimation, loop = false, frames = { 45, 46, 47 } })
    local x, y = getPositionAtCoordonate(i, j)
    self:moveTo(x, y)
    self:setZIndex(zIndex)
    self:playAnimation()
    self:setCollideRect(0, 0, 16, 16)
    self:setGroups({ collisionGroup.block })

    self.states.destructionAnimation.onAnimationEndEvent = function(self)
        self:remove()
    end
end

function BreakableBlock:startBreak()
    self:changeState('destructionAnimation', true)
end

function BreakableBlock:update()
    BreakableBlock.super.update(self)
end
