

class('BreakableBlock').extends(ObjectMap)

function BreakableBlock.new(i,j)
    return BreakableBlock(i, j)
end

function BreakableBlock:init(i, j)
    BreakableBlock.super.init(self, i, j, 3, true)
    local speedAnimation = 10

    self:addState('block', 44, 44, { tickStep = speedAnimation }).asDefault()
    self:addState('destruction', 1, 3, { tickStep = speedAnimation, loop = false, frames = { 45, 46, 47 } })

    self.states.destruction.onAnimationEndEvent = function(self)
       self:remove()
    end

    self:setGroups({ collisionGroup.block })
    -- self:setCollidesWithGroups({ })
    self:playAnimation()
end

function BreakableBlock:startBreak()
   self:changeState('destruction', true)
end

function BreakableBlock:update()
    BreakableBlock.super.update(self)
end
