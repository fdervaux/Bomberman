class('UnbreakableBlock').extends(ObjectMap)

function UnbreakableBlock.new(i, j)
    return UnbreakableBlock(i, j)
end

function UnbreakableBlock:init(i, j)
    local imageIndex = 43
    UnbreakableBlock.super.init(self, i, j, 2, true)
    self:setGroups({ collisionGroup.block })
    self:setStaticImage(imageIndex)
end
