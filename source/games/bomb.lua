class('Bomb').extends(ObjectMap)

function Bomb.new(i, j, power)
    return Bomb(i, j, power)
end

function Bomb:init(i, j, power)
    Bomb.super.init(self, i, j, 3, true)

    self.maxSpeed = 4;
    self.velocity = playdate.geometry.vector2D.new(0, 0)

    local sound = playdate.sound.sampleplayer
    self.bombExplode = sound.new('sounds/Bomb Explodes.wav')

    local animationSpeed = 10

    self.power = power
    self.isExploded = false
    self.canPush = false

    self:addState('BombStart', 1, 3, {
        tickStep = animationSpeed,
        yoyo = true,
        loop = 4,
        nextAnimation = 'Bomb',
        frames = { 29, 30, 31 }
    }).asDefault()
    self:addState('Bomb', 1, 10, {
        tickStep = animationSpeed / 2,
        yoyo = true,
        loop = false,
        frames = { 30, 31, 30, 29, 30, 31, 30, 29, 30, 31 }
    })

    self:playAnimation()
    self:setGroups(collisionGroup)
    self:setCollideRect(0, 0, 16, 16)

    local bombCollisionGroups = {}

    local _, _, collisions, _ = self:checkCollisions(self.x, self.y)
    for i = 1, #collisions, 1 do
        if (collisions[i].other == player1) then
            bombCollisionGroups[#bombCollisionGroups + 1] = collisionGroup.ignoreP1
        end

        if (collisions[i].other == player2) then
            bombCollisionGroups[#bombCollisionGroups + 1] = collisionGroup.ignoreP2
        end
    end
    bombCollisionGroups[#bombCollisionGroups + 1] = collisionGroup.bomb

    self:setGroups(bombCollisionGroups)

    self:setCollidesWithGroups({ collisionGroup.p1, collisionGroup.p2, collisionGroup.bomb, collisionGroup.item,
        collisionGroup.block })

    self.states.Bomb.onAnimationEndEvent = function(self)
        self:explode()
    end
end

function Bomb:push(direction)
    self.velocity = direction;
end

function Bomb:explodeDirection(i, j, di, dj)
    local sprites = playdate.graphics.sprite.querySpritesAtPoint(getPositionAtCoordonate(i + di, j + dj))

    local needToCreateExplosion = true

    if sprites ~= nil then
        for index = 1, #sprites, 1 do
            local sprite = sprites[index]

            if sprite ~= nil then
                if sprite:isa(Item) then
                    sprite:remove()
                    world:addNewElement(ItemExplode, i + di, j + dj)
                    return true
                end

                if sprite:isa(BreakableBlock) then
                    sprite:startBreak()
                    return true
                end

                if sprite:isa(UnbreakableBlock) then
                    return true
                end

                if sprite:isa(Bomb) then
                    playdate.timer.performAfterDelay(50, sprite.explode, sprite)
                    return true
                end

                if sprite:isa(Player) then
                    playdate.timer.performAfterDelay(50, sprite.kill, sprite)
                end

                if sprite:isa(Explosion) then
                    needToCreateExplosion = false
                    local state = sprite.currentState
                    sprite:stopAnimation()
                    sprite:changeState(state, true)
                    sprite:changeState('explosionMiddle', true)
                end
            end
        end
    end

    if needToCreateExplosion then
        if di == self.power then
            world:addNewElement(Explosion, i + di, j + dj, 'explosionRight')
        elseif di == -self.power then
            world:addNewElement(Explosion, i + di, j + dj, 'explosionLeft')
        elseif dj == -self.power then
            world:addNewElement(Explosion, i + di, j + dj, 'explosionUp')
        elseif dj == self.power then
            world:addNewElement(Explosion, i + di, j + dj, 'explosionDown')
        elseif di > 0 or di < 0 then
            world:addNewElement(Explosion, i + di, j + dj, 'explosionHorizontal')
        elseif dj > 0 or dj < 0 then
            world:addNewElement(Explosion, i + di, j + dj, 'explosionVertical')
        end
    end

    return false
end

function Bomb:explode()
    self:remove()
    self.isExploded = true

    self.bombExplode:play(1, 1)
    local screenShaker = ScreenShaker()
    screenShaker:start(0.8, 3, playdate.easingFunctions.inOutCubic)

    local i, j = getCoordonateAtPosition(self.x, self.y)

    invertedCircle:addBomb(self.power, i, j)

    world:addNewElement(Explosion, i, j, 'explosionMiddle')

    for index = 1, self.power, 1 do
        if self:explodeDirection(i, j, index, 0) then
            break
        end
    end

    for index = 1, self.power, 1 do
        if self:explodeDirection(i, j, -index, 0) then
            break
        end
    end

    for index = 1, self.power, 1 do
        if self:explodeDirection(i, j, 0, -index) then
            break
        end
    end

    for index = 1, self.power, 1 do
        if self:explodeDirection(i, j, 0, index) then
            break
        end
    end
end

function Bomb:update()
    Bomb.super.update(self)

    if hasGroup(self:getGroupMask(), collisionGroup.ignoreP1) then
        local collideWithPlayer1 = false
        local sprites = player1:overlappingSprites()

        for i = 1, #sprites, 1 do
            if (sprites[i] == self) then
                collideWithPlayer1 = true
            end
        end

        if not collideWithPlayer1 then
            self:setGroupMask(self:getGroupMask() - bit(collisionGroup.ignoreP1))
        end
    end

    if hasGroup(self:getGroupMask(), collisionGroup.ignoreP2) then
        local collideWithPlayer2 = false
        local sprites = player2:overlappingSprites()

        for i = 1, #sprites, 1 do
            if (sprites[i] == self) then
                collideWithPlayer2 = true
            end
        end

        if not collideWithPlayer2 then
            self:setGroupMask(self:getGroupMask() - bit(collisionGroup.ignoreP2))
        end
    end

    local oldX, oldY, _, _ = self:getPosition()
    local x, y, _, _ = self:moveWithCollisions(self.x + self.velocity.x * self.maxSpeed,
        self.y + self.velocity.y * self.maxSpeed)

    local i, j = getCoordonateAtPosition(x, y)

    self.velocity = playdate.geometry.vector2D.new(x - oldX, y - oldY) / self.maxSpeed
end
