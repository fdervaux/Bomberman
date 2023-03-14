class('InvertedCircle').extends(NobleSprite)

function starPolygon(centerX, centerY, nbSommet, innerRadius, outerRadius, angle)
    local polygon = playdate.geometry.polygon.new(nbSommet * 2)

    local step = math.pi / nbSommet

    local angle = 0 + angle

    for i = 1, nbSommet * 2, 1 do
        local radius = i % 2 == 0 and outerRadius or innerRadius

        print("radius " .. radius)


        local x = centerX + radius * math.cos(angle)
        local y = centerY + radius * math.sin(angle)

        polygon:setPointAt(i, x, y)

        angle = angle + step
    end

    polygon:close()

    return polygon
end

function InvertedCircle:init()
    InvertedCircle.super.init(self)

    self.animator = playdate.graphics.animator.new(1000, 50, 0, playdate.easingFunctions.inCubic)
    self:setSize(400, 240)
    self:setZIndex(200)
    self:add()
    self:moveTo(200, 120)
    self.bombTable = {}
    self.circlesImage = playdate.graphics.image.new(400, 240)
end

function InvertedCircle:addBomb(power, i, j)
    local x, y = getPositionAtCoordonate(i, j)
    self.bombTable[#self.bombTable + 1] = {
        playdate.graphics.animator.new(1000, 16 + 16 * power, 0, playdate.easingFunctions.inCubic), x, y }
end

function InvertedCircle:draw()
    print("test")
    playdate.graphics.pushContext(self.circlesImage)
    playdate.graphics.setColor(playdate.graphics.kColorClear)
    playdate.graphics.fillRect(0, 0, 400, 240)
    playdate.graphics.setColor(playdate.graphics.kColorBlack)

    for _, value in pairs(self.bombTable) do
        local size = value[1]:currentValue()
        -- self.polygon = starPolygon(value[2], value[3], 8, 2 * size / 3, size, size * 10)
        -- playdate.graphics.fillPolygon(self.polygon)
        playdate.graphics.fillCircleAtPoint(value[2], value[3], size)
    end

    playdate.graphics.popContext()
    playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeNXOR)
    self.circlesImage:draw(0, 0)
    playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeCopy)
end

function InvertedCircle:update()
    InvertedCircle.super.update(self)

    if #self.bombTable > 0 then
        self:markDirty()
    end

    for i = #self.bombTable, 1, -1 do
        if self.bombTable[i][1]:ended() then
            table.remove(self.bombTable, i)
        end
    end
end
