class('StaticSprite').extends(NobleSprite)

function StaticSprite:init(i, j, imageIndex, zIndex, hasCollider)
    StaticSprite.super.init(self)

    self:add()

    local x, y = getPositionAtCoordonate(i, j)
    self:moveTo(x, y)
    local image = envImagetable:getImage(imageIndex)
    self:setImage(image)
    self:setZIndex(zIndex)

    if hasCollider then
        self:setCollideRect(0, 0, self:getSize())
    end
end

class('EmptySprite').extends(playdate.graphics.sprite)

function EmptySprite:init(i, j)
    local x, y = getPositionAtCoordonate(i, j)
    self:moveTo(x, y)
    self:setImage(image)
    self:setZIndex(10)
    self:setCollideRect(0, 0, 16, 16)
end
