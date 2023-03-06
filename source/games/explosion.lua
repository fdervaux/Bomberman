import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "games/utils.lua"
import "games/bomb.lua"
import "libraries/animatedSprite/AnimatedSprite.lua"


class('Explosion').extends(AnimatedSprite)

function Explosion:init(i, j, explosionState)
    Explosion.super.init(self, envImagetable)

    local animationSpeed = 5

    self:addState('explosionLeft', 1, 5,
        { tickStep = animationSpeed, frames = { 15, 8, 1, 8, 15 }, loop = false })
    self:addState('explosionHorizontal', 1, 5,
        { tickStep = animationSpeed, frames = { 16, 9, 2, 9, 16 }, loop = false })
    self:addState('explosionMiddle', 1, 5,
        { tickStep = animationSpeed, frames = { 17, 10, 3, 10, 17 }, loop = false }).asDefault()
    self:addState('explosionRight', 1, 5,
        { tickStep = animationSpeed, frames = { 18, 11, 4, 11, 18 }, loop = false })
    self:addState('explosionUp', 1, 5,
        { tickStep = animationSpeed, frames = { 19, 12, 5, 12, 19 }, loop = false })
    self:addState('explosionVertical', 1, 5,
        { tickStep = animationSpeed, frames = { 20, 13, 6, 13, 20 }, loop = false })
    self:addState('explosionDown', 1, 5,
        { tickStep = animationSpeed, frames = { 21, 14, 7, 14, 21 }, loop = false })

    for _, state in pairs(self.states) do
        state.onAnimationEndEvent = function(self)
            self:remove()
        end
    end

    self:changeState(explosionState, true)
    local x, y = getPositionAtCoordonate(i, j)
    self:moveTo(x, y)
    self:setZIndex(3)
    self:playAnimation()
    self:setGroups({ collisionGroup.explosion })
    self:setCollidesWithGroups({ collisionGroup.bomb, collisionGroup.p1, collisionGroup.p2, collisionGroup.item,
        collisionGroup.block })
    self:setCollideRect(0, 0, 16, 16)
end
