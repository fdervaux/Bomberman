import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "games/utils.lua"
import "games/explosion.lua"
import "Plugins/AnimatedSprite/AnimatedSprite.lua"


class('Bomb').extends(AnimatedSprite)

function Bomb:init(i, j, power)
    Bomb.super.init(self, envImagetable)

    local animationSpeed = 20

    self.power = power

    self:addState('Bomb', 29, 31,
        { tickStep = animationSpeed, yoyo = true, loop = 4 }).asDefault()

    local x, y = getPositionAtCoordonate(i, j)
    self:moveTo(x, y)
    self:setZIndex(3)
    self:playAnimation()
    self:setGroups(collisionGroup)
    self:setCollideRect(0, 0, 16, 16)

    local bombCollisionGroups = {}

    local _, _, collisions, _ = self:checkCollisions(x, y)
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
    self:setCollidesWithGroups({ collisionGroup.p1, collisionGroup.p2 })

    self.states.Bomb.onAnimationEndEvent = function(self)
        self:remove()
        self:explode()
    end
end

function Bomb:explode()
    local i, j = getCoordonateAtPosition(self.x, self.y)
    local explosion = Explosion(i, j, 'explosionMiddle')
    explosion:add()

    for index = 1, self.power, 1 do
        local case = world.worldTable[i + index][j]

        if (case:isa(BreakableBlock) or case:isa(UnbreakableBlock)) then
            break
        end

        if index == self.power then
            explosion = Explosion(i + index, j, 'explosionRight')
            explosion:add()
        else
            explosion = Explosion(i + index, j, 'explosionHorizontal')
            explosion:add()
        end
    end


    for index = 1, self.power, 1 do
        local case = world.worldTable[i - index][j]

        if (case:isa(BreakableBlock) or case:isa(UnbreakableBlock)) then
            break
        end

        if index == self.power then
            explosion = Explosion(i - index, j, 'explosionLeft')
            explosion:add()
        else
            explosion = Explosion(i - index, j, 'explosionHorizontal')
            explosion:add()
        end
    end    

    for index = 1, self.power, 1 do
        local case = world.worldTable[i][j + index]

        if (case:isa(BreakableBlock) or case:isa(UnbreakableBlock)) then
            break
        end

        if index == self.power then
            explosion = Explosion(i, j+ index, 'explosionDown')
            explosion:add()
        else
            explosion = Explosion(i, j+ index, 'explosionVertical')
            explosion:add()
        end
    end    

    for index = 1, self.power, 1 do
        local case = world.worldTable[i][j - index]

        if (case:isa(BreakableBlock) or case:isa(UnbreakableBlock)) then
            break
        end

        if index == self.power then
            explosion = Explosion(i, j - index, 'explosionUp')
            explosion:add()
        else
            explosion = Explosion(i, j - index, 'explosionVertical')
            explosion:add()
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
end
