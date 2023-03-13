world = nil
player1 = nil
player2 = nil

class('World').extends(NobleScene)

function World:init()
    World.super.init(self)
    World.inputHandler = {
        upButtonHold = function()
            player1:Move(playdate.geometry.vector2D.new(player1.velocity.x, -1))
        end,
        downButtonHold = function()
            player1:Move(playdate.geometry.vector2D.new(player1.velocity.x, 1))
        end,
        leftButtonHold = function()
            player1:Move(playdate.geometry.vector2D.new(-1, player1.velocity.y))
        end,
        rightButtonHold = function()
            player1:Move(playdate.geometry.vector2D.new(1, player1.velocity.y))
        end,
        AButtonDown = function()
            player1:dropBomb()
        end
    }
end

function World:updateFloor(i, j)
    local floor = self:getElementOfTypeAt(Floor, i, j)

    local caseTable = self.worldTable[i][j - 1]
    local shadow = containsClass(caseTable, UnbreakableBlock) or containsClass(caseTable, BreakableBlock)

    if floor then
        floor:setShadow(shadow)
    end
end

function World:removeElement(i, j, item)
    local caseTable = self.worldTable[i][j]
    local indexToRemove = indexOfItem(caseTable, item)

    if indexToRemove then
        table.remove(caseTable, indexToRemove)
    end
    

    if item.class == BreakableBlock then
        world:updateFloor(i, j)
        world:updateFloor(i, j + 1)
        local pick = getObjectOfClass(caseTable, Item)

        if pick then
            pick:activate()
        end
    end
end

function World:getElementOfTypeAt(type, i, j)
    for _, value in pairs(self.worldTable[i][j]) do
        if (value.class == type) then
            return value
        end
    end
    return nil
end

function World:addNewElement(type, i, j, ...)
    local caseTable = self.worldTable[i][j]
    caseTable[#caseTable + 1] = type.new(i, j, ...)
end

function World:addFloor(i, j)
    local caseTable = self.worldTable[i][j - 1]
    local shadow = containsClass(caseTable, UnbreakableBlock) or containsClass(caseTable, BreakableBlock)

    self:addNewElement(Floor, i, j, shadow)
end

function World:enter()
    World.super.enter(self)

    world = self;
    player1 = Player(2, 2, P1)
    player2 = Player(14, 14, p2)

    playdate.graphics.setBackgroundColor(playdate.graphics.kColorBlack)
    math.randomseed(playdate.getSecondsSinceEpoch())

    self.worldTable = {}

    for i = 1, 15, 1 do
        self.worldTable[i] = {}
        for j = 1, 15, 1 do
            self.worldTable[i][j] = {}
        end
    end

    for i = 1, 15, 1 do
        self:addNewElement(UnbreakableBlock, i, 1)
        self:addNewElement(UnbreakableBlock, i, 15)
    end

    for i = 3, 13, 2 do
        for j = 3, 13, 2 do
            self:addNewElement(UnbreakableBlock, i, j)
        end
    end

    for j = 2, 14, 1 do
        self:addNewElement(UnbreakableBlock, 1, j)
        self:addNewElement(UnbreakableBlock, 15, j)
    end

    local emptySpace = {}
    local emptySpaceIndex = 1

    self:addNewElement(Empty, 2, 2)
    self:addNewElement(Empty, 3, 2)
    self:addNewElement(Empty, 2, 3)

    self:addNewElement(Empty, 14, 14)
    self:addNewElement(Empty, 14, 13)
    self:addNewElement(Empty, 13, 14)

    for i = 1, 15, 1 do
        for j = 1, 15, 1 do
            if #self.worldTable[i][j] <= 0 then
                emptySpace[emptySpaceIndex] = { i, j }
                emptySpaceIndex = emptySpaceIndex + 1
            end
        end
    end

    local items = {}
    for i = 1, 10, 1 do
        items[#items + 1] = FlameItem
        items[#items + 1] = BombItem
        items[#items + 1] = SpeedItem
    end
    for i = 1, 2, 1 do
        items[#items + 1] = KickItem
    end
    items[#items + 1] = MegaFlameItem

    local index = 1
    local nbBloc = 100

    while nbBloc ~= 0 do
        local elementsIndex = math.random(#emptySpace)
        local coord = table.remove(emptySpace, elementsIndex)
        local i = coord[1]
        local j = coord[2]

        self:addNewElement(BreakableBlock, i, j)

        if index <= #items then
            self:addNewElement(items[index], i, j)
            index = index + 1
        end
        nbBloc = nbBloc - 1
    end

    for i = 2, 14, 1 do
        for j = 2, 14, 1 do
            self:addFloor(i, j)
        end
    end

    local sound = playdate.sound.sampleplayer
    self.backgroundMusic = sound.new('sounds/SBomb1-Battle.wav')
    self.stageIntro = sound.new('sounds/Stage Intro.wav')

    self.backgroundMusic:setVolume(0.3)
    self.stageIntro:play(1, 1)
    self.playatend = true
    self.stageIntro:setFinishCallback(function()
        if self.playatend == true then
            self.backgroundMusic:play(0, 1)
        end
    end)
    local menu = playdate.getSystemMenu()

    self.menuItem = menu:addMenuItem("Title Screen", function()
        Noble.transition(MenuScene, 0.5, Noble.TransitionType.SLIDE_OFF_RIGHT)
    end)
end

function World:endGame(isWinning)
    gameGlobalVariables.isWinning = isWinning
    Noble.transition(EndScene, 0.5, Noble.TransitionType.SLIDE_OFF_LEFT)
end

function World:exit()
    World.super.exit(self)

    self.stageIntro:stop()
    self.playatend = false
    self.backgroundMusic:stop()

    local menu = playdate.getSystemMenu()
    menu:removeMenuItem(self.menuItem)
end
