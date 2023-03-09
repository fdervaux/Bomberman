P1 = 0
P2 = 1

class('Player').extends(AnimatedSprite)

function Player:init(i, j, playerNumber)
    Player.super.init(self, playerImagetable, nil, nil)


    local sound = playdate.sound.sampleplayer
    self.walk1Sound = sound.new('sounds/Walking 1.wav')
    self.walk2Sound = sound.new('sounds/Walking 2.wav')
    self.bombDrop = sound.new('sounds/Place Bomb.wav')
    self.shiftY = 0
    self.shiftX = 0
    
    self.nbBombMax = 1
    self.bombs = {}
    self.power = 1
    self.isDead = false
    self.maxSpeed = 2
    self.canKick = false

    local playerShift = playerNumber == P1 and 0 or 5
    local speed = 10

    self:addState("dead", 64 + playerShift, 67 + playerShift, {tickStep = speed, loop = false})

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


    self.states.dead.onAnimationEndEvent = function (self)
        self:remove()
        playdate.timer.performAfterDelay(500, function ()
            print(self)
            print(self == player1)
            world:endGame(self ~= player1)
        end)
    end

    self:setCollideRect(10, 18, 12, 12)
    local playerCollisionGroup = playerNumber == P1 and collisionGroup.player1 or collisionGroup.player2
    self:setGroups({ playerCollisionGroup })
    self:setCollidesWithGroups({ collisionGroup.block, collisionGroup.bomb, collisionGroup.bomb, collisionGroup.item, collisionGroup.p1, collisionGroup.p2, collisionGroup.explosion})

    local x, y = getPositionAtCoordonate(i, j)
    self:moveTo(x, y - 8)
    self:playAnimation()
    self:setZIndex(4)

    self.lastDirection = 'Down'
    self.velocity = playdate.geometry.vector2D.new(0, 0)
    
end

function Player:Move(playerDirection)
    local velocity = playerDirection
    velocity:normalize()
    -- velocity:scale(self.maxSpeed)
    self.velocity = velocity
end

function Player:collisionResponse(other)
    if hasGroup(other:getGroupMask(),collisionGroup.explosion) then
        self:kill()
        return 'overlap'
    end
    if hasGroup(other:getGroupMask(),collisionGroup.item) then 
        other:take()

        if other:isa(BombItem) then
            self.nbBombMax += 1
        end

        if other:isa(FlameItem) then
            self.power += 1
        end
        
        if other:isa(MegaFlameItem) then
            self.power += 10
        end

        if other:isa(SpeedItem) then
            self.maxSpeed += 0.5
        end

        if other:isa(KickItem) then
            self.canKick = true
        end

        return 'overlap'
    end
    if hasGroup(other:getGroupMask(),collisionGroup.ignoreP1) and self == player1 then 
        return 'overlap'
    end

    if hasGroup(other:getGroupMask(),collisionGroup.ignoreP2) and self == player2 then 
        return 'overlap'
    end

    if(hasGroup(other:getGroupMask(), collisionGroup.block)) then

        self.shiftY = 0
        self.shiftX = 0
        if self.velocity.x > 0 or self.velocity.x < 0 then
            
            if self.y + 8 > other.y then
                self.shiftY = other.y - self.y - 8 + 14
            else
                self.shiftY = other.y - self.y - 8 - 14
            end
        end

        if self.velocity.y > 0 or self.velocity.y < 0 then
            
            if self.x > other.x then
                self.shiftX = other.x - self.x + 14
            else
                self.shiftX = other.x - self.x - 14
            end
        end
    end


    return 'slide'
end

function Player:dropBomb()
    local sprites = playdate.graphics.sprite.querySpritesAtPoint(self.x, self.y + 8)

    if sprites~=nil then
        for i = 1, #sprites, 1 do
            if sprites[i]:isa(Bomb) then
                return
            end
        end
    end

    if #self.bombs >= self.nbBombMax then
        return
    end

    local i, j = getCoordonateAtPosition(self.x, self.y + 8)

    self.bombs[#self.bombs+1] = Bomb(i,j, self.power)
    self.bombDrop:play(1,1)
end

function Player:kill()
    self.isDead = true
end

function Player:update()
    Player.super.update(self)

    if self.isDead then
        self:changeState('dead',true)
        return    
    end

    local oldX, oldY, _, _ = self:getPosition()

    local x, y, collisions, _ = self:moveWithCollisions(self.x + self.velocity.x * self.maxSpeed, self.y + self.velocity.y * self.maxSpeed)

    local tolerance = 8

    if self.canKick then
        for i = 1, #collisions, 1 do
            local other = collisions[i].other
            if not hasGroup(other:getGroupMask(), collisionGroup.ignoreP1) and other:isa(Bomb) then
                
                collisions[i].other:push( - collisions[i].normal) 
            end
        end
    end
    


    if self.shiftY < tolerance and self.shiftY > -tolerance then
        self.y += self.shiftY
    end
    if self.shiftX < tolerance and self.shiftX > -tolerance then
        self.x += self.shiftX
    end

    self.velocity = playdate.geometry.vector2D.new(x - oldX, y - oldY)

    if self.velocity.y ~= 0 or self.velocity.x ~= 0 then
        if not self.walk1Sound:isPlaying() then
            self.walk1Sound:play(1,1)
        end
    end 


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

    self.velocity.x = 0
    self.velocity.y = 0
    self.shiftY = 0
    self.shiftX = 0

    if #self.bombs > 0 and self.bombs[1].isExploded then
        table.remove(self.bombs,1)
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


