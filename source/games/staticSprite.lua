import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "games/utils.lua"

class('StaticSprite').extends(playdate.graphics.sprite)



function StaticSprite:init(i, j, imageIndex, zIndex, hasCollider)
    local x, y = getPositionAtCoordonate(i, j)
    self:moveTo(x, y)
    local image = envImagetable:getImage(imageIndex)
    self:setImage(image)
    self:setZIndex(zIndex)

    if hasCollider then
        self:setCollideRect(0, 0, self:getSize())
    end
end
