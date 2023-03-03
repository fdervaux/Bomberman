import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "games/utils.lua"
import "Plugins/AnimatedSprite/AnimatedSprite.lua"


class('Explosion').extends(AnimatedSprite)

function Explosion:init(i, j, explosionState)
    Explosion.super.init(self, envImagetable)

    local animationSpeed = 7

    self:addState('explosionLeft', 1, 4,
        { tickStep = animationSpeed, frames = { 1, 8, 15, 22 }, loop = false })
    self:addState('explosionHorizontal', 1, 4,
        { tickStep = animationSpeed, frames = { 2, 9, 16, 23 }, loop = false })
    self:addState('explosionMiddle', 1, 4,
        { tickStep = animationSpeed, frames = { 3, 10, 17, 24 }, loop = false }).asDefault()
    self:addState('explosionRight', 1, 4,
        { tickStep = animationSpeed, frames = { 4, 11, 18, 25 }, loop = false })
    self:addState('explosionUp', 1, 4,
        { tickStep = animationSpeed, frames = { 5, 12, 19, 26 }, loop = false })
    self:addState('explosionVertical', 1, 4,
        { tickStep = animationSpeed, frames = { 6, 13, 20, 27 }, loop = false })
    self:addState('explosionDown', 1, 4,
        { tickStep = animationSpeed, frames = { 7, 14, 21, 28 }, loop = false })

    for _,state in pairs(self.states) do
        state.onAnimationEndEvent = function(self)
            self:remove()
        end
    end

    self:changeState(explosionState,true)
    local x, y = getPositionAtCoordonate(i, j)
    self:moveTo(x, y)
    self:setZIndex(3)
    self:playAnimation()
    self:setGroups(collisionGroup)
    self:setCollideRect(0, 0, 16, 16)

    print("init explosion")
end
