import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "libraries/animatedSprite/AnimatedSprite.lua"
import "games/utils.lua"

class('ItemExplode').extends(AnimatedSprite)

function ItemExplode:init(i, j, zIndex)
    ItemExplode.super.init(self, envImagetable)
    local speedAnimation = 10
    self:addState('destructionAnimation', 1, 4, { tickStep = speedAnimation, loop = false, frames = { 50, 51, 52, 53 } })
    local x, y = getPositionAtCoordonate(i, j)
    self:moveTo(x, y)
    self:setZIndex(zIndex)
    self:playAnimation()
    self:setCollideRect(0, 0, 16, 16)
    self:setGroups({ collisionGroup.explosion })

    self.states.destructionAnimation.onAnimationEndEvent = function(self)
        self:remove()
    end
end

class('Item').extends(StaticSprite)

function Item:init(i, j, imageIndex)
    Item.super.init(self, i, j, imageIndex, 2, true)
    self:setGroups({ collisionGroup.item })
    local sound = playdate.sound.sampleplayer
    self.takeItem = sound.new('sounds/Item Get.wav')

    self:setCollideRect(2, 2, 12, 12)
end

function Item:take()
    self:remove()
    self.takeItem:play(1, 1)
end

class('BombItem').extends('Item')

function BombItem:init(i, j)
    BombItem.super.init(self, i, j, 40)
end

class('FlameItem').extends('Item')

function FlameItem:init(i, j)
    FlameItem.super.init(self, i, j, 38)
end

class('MegaFlameItem').extends('Item')

function MegaFlameItem:init(i, j)
    MegaFlameItem.super.init(self, i, j, 39)
end

class('SpeedItem').extends('Item')

function SpeedItem:init(i, j)
    SpeedItem.super.init(self, i, j, 37)
end

class('BreakableBlock').extends(AnimatedSprite)

function BreakableBlock:init(i, j, zIndex, item)
    BreakableBlock.super.init(self, envImagetable)
    local speedAnimation = 10
    self:addState('block', 44, 44, { tickStep = speedAnimation }).asDefault()
    self:addState('destruction', 1, 3, { tickStep = speedAnimation, loop = false, frames = { 45, 46, 47 } })
    local x, y = getPositionAtCoordonate(i, j)
    self:moveTo(x, y)
    self:setZIndex(3)

    self:setCollideRect(0, 0, 16, 16)
    self:setGroups({ collisionGroup.block })
    self.item = item
    self.states.destruction.onAnimationEndEvent = function(self)
        self:remove()
        if self.item == nil then
            return
        end

        if self.item == "BombItem" then
            BombItem(i, j)
        end

        if self.item == "FlameItem" then
            FlameItem(i, j)
        end

        if self.item == "SpeedItem" then
            SpeedItem(i, j)
        end

        if self.item == "MegaFlameItem" then
            MegaFlameItem(i, j)
        end
    end

    self:playAnimation()
end

function BreakableBlock:startBreak()
    self:changeState('destruction', true)
end

function BreakableBlock:update()
   BreakableBlock.super.update(self)
end
