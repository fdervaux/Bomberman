class('Floor').extends(ObjectMap)

function Floor.new(i, j, shadow)
    return Floor(i, j, shadow)
end

function Floor:setShadow(shadow)
    local imageIndex = shadow and 48 or 49
    local image = envImagetable:getImage(imageIndex)
    self:setImage(image)
    print (shadow)
end

function Floor:init(i, j, shadow)
    local imageIndex = shadow and 48 or 49
    Floor.super.init(self, i, j, 1, false)

    self:setStaticImage(imageIndex)
end
