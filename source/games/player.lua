import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "games/utils.lua"
import "Plugins/AnimatedSprite/AnimatedSprite.lua"
import "games/world.lua"

P1 = 0
P2 = 1

class('Player').extends(AnimatedSprite)

function Player:init(i, j, playerNumber)
    Player.super.init(self, playerImagetable, nil, nil)

    self.power = 3

    local playerShift = playerNumber == P1 and 0 or 5
    local speed = 10

    self:addState('p1IdleUp', 1 + playerShift, 1 + playerShift, { tickStep = speed })
    self:addState('p1RunUp', 1, 3,
        { tickStep = speed, yoyo = true, frames = { 2 + playerShift, 1 + playerShift, 3 + playerShift } })

    self:addState('p1IdleRight', 10 + playerShift, 10 + playerShift, { tickStep = speed })
    self:addState('p1RunRight', 1, 3,
        { tickStep = speed, yoyo = true, frames = { 11 + playerShift, 10 + playerShift, 12 + playerShift } })

    self:addState('p1IdleDown', 19 + playerShift, 19 + playerShift, { tickStep = speed }).asDefault()
    self:addState('p1RunDown', 1, 3,
        { tickStep = speed, yoyo = true, frames = { 20 + playerShift, 19 + playerShift, 21 + playerShift } })

    self:addState('p1IdleLeft', 28 + playerShift, 28 + playerShift, { tickStep = speed })
    self:addState('p1RunLeft', 1, 3,
        { tickStep = speed, yoyo = true, frames = { 29 + playerShift, 28 + playerShift, 30 + playerShift } })

    self:setCollideRect(10, 18, 12, 12)
    local playerCollisionGroup = playerNumber == P1 and collisionGroup.player1 or collisionGroup.player2
    self:setGroups({ playerCollisionGroup })
    self:setCollidesWithGroups({ collisionGroup.block, collisionGroup.bomb, collisionGroup.bomb, collisionGroup.item, collisionGroup.p1, collisionGroup.p2})

    local x, y = getPositionAtCoordonate(i, j)
    self:moveTo(x, y - 8)
    self:playAnimation()
    self:setZIndex(4)

    self.lastDirection = 'Down'
    self.velocity = playdate.geometry.vector2D.new(0, 0)
    self.maxSpeed = 2
end

function Player:Move(playerDirection)
    local velocity = playerDirection
    velocity:normalize()
    velocity:scale(self.maxSpeed)
    self.velocity = velocity
end

function Player:collisionResponse(other)
    if hasGroup(other:getGroupMask(),collisionGroup.item) then 
        return 'overlap'
    end
    if hasGroup(other:getGroupMask(),collisionGroup.ignoreP1) and self == player1 then 
        return 'overlap'
    end

    if hasGroup(other:getGroupMask(),collisionGroup.ignoreP2) and self == player2 then 
        return 'overlap'
    end

    return 'slide'
end

function Player:dropBomb()
    local i, j = getCoordonateAtPosition(self.x, self.y + 8)
    world:addBomb(i, j, self.power)
end

function Player:update()
    Player.super.update(self)

    local oldX, oldY, _, _ = self:getPosition()

    local x, y, _, _ = self:moveWithCollisions(self.x + self.velocity.x, self.y + self.velocity.y)

    self.velocity = playdate.geometry.vector2D.new(x - oldX, y - oldY)

    if self.velocity.y < 0 then
        self:changeState('p1RunUp', true)
        self.lastDirection = "Up"
    elseif self.velocity.x > 0 then
        self:changeState('p1RunRight', true)
        self.lastDirection = "Right"
    elseif self.velocity.y > 0 then
        self:changeState('p1RunDown', true)
        self.lastDirection = "Down"
    elseif self.velocity.x < 0 then
        self:changeState('p1RunLeft', true)
        self.lastDirection = "Left"
    else
        self:changeState('p1Idle' .. self.lastDirection, true)
    end
end

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

player1 = Player(2, 2, P1)
player2 = Player(24, 14, p2)
