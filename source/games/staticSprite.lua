class('ObjectMap').extends(AnimatedSprite)

function ObjectMap:remove()
    world:removeElement(self.i, self.j, self)
    ObjectMap.super.remove(self)
end

function ObjectMap:setStaticImage(imageIndex)
    local image = envImagetable:getImage(imageIndex)
    self:setImage(image)
end

function ObjectMap:init(i, j, zIndex, hasCollider)
    ObjectMap.super.init(self, envImagetable)
    self:add()
    self.i = i
    self.j = j
    local x, y = getPositionAtCoordonate(i, j)
    self:moveTo(x, y)
    self:setZIndex(zIndex)
    if hasCollider then
        self:setCollideRect(0, 0, 16, 16)
    end
end
