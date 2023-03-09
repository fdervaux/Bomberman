world = nil
player1 = nil
player2 = nil

class('WorldScene').extends(NobleScene)

function WorldScene:init()
	WorldScene.super.init(self)

    WorldScene.inputHandler = {
		upButtonHold = function()
			player1:Move(playdate.geometry.vector2D.new(player1.velocity.x,-1))
		end,
		downButtonHold = function()
			player1:Move(playdate.geometry.vector2D.new(player1.velocity.x,1))
		end,
        leftButtonHold = function()
			player1:Move(playdate.geometry.vector2D.new(-1,player1.velocity.y))
		end,
        rightButtonHold = function()
			player1:Move(playdate.geometry.vector2D.new(1,player1.velocity.y))
		end,
		AButtonDown = function()
			player1:dropBomb()
		end
	}
end

function WorldScene:enter()
    WorldScene.super.enter(self)

    world = self;
    player1 = Player(2, 2, P1)
    player2 = Player(24, 14, p2)

    playdate.graphics.setBackgroundColor(playdate.graphics.kColorBlack)
        
    math.randomseed(playdate.getSecondsSinceEpoch())
    self.worldTable = {}
    self.objectInWorld = {}

    for i = 1,24,1 do
        self.worldTable[i] = {}
        for j = 1, 15, 1 do
            self.worldTable[i][j] = {}
        end
    end

    for i = 1, 25, 1 do
        local caseLineUp = self.worldTable[i][1]
        caseLineUp[#caseLineUp+1] =  UnbreakableBlock( i, 1, 1)

        local caseLineDown = self.worldTable[i][15]
        caseLineDown[#caseLineDown+1] =  UnbreakableBlock( i, 15, 1)
    end

    for i = 3, 23, 2 do
        for j = 3, 13, 2 do
            local case = self.worldTable[i][j]
            case[#case+1] = UnbreakableBlock(i, j, 1)
        end
    end

    for j = 2, 14, 1 do
        local caseLineLeft = self.worldTable[1][j]
        caseLineLeft[#caseLineLeft+1] =  UnbreakableBlock( 1, j, 1)

        local caseLineRight = self.worldTable[25][j]
        caseLineRight[#caseLineRight+1] =  UnbreakableBlock( 25, j, 1)
    end

    local emptySpace = {}
    local emptySpaceIndex = 1

    self.worldTable[2][2] = {Floor(2,2,1,true)}
    self.worldTable[3][2] = {Floor(3,2,1,true)}
    self.worldTable[2][3] = {Floor(2,3,1,false)}

    self.worldTable[24][14] = {Floor(24,14,1,false)}
    self.worldTable[24][13] = {Floor(24,13,1,false)}
    self.worldTable[23][14] = {Floor(23,14,1,true )}
    
    for i = 1, 25, 1 do
        for j = 1, 15, 1 do
            if #self.worldTable[i][j] == 0 then
                emptySpace[emptySpaceIndex] = {i,j}
                emptySpaceIndex += 1
            end
        end
    end


    local items = {}
    for i=1,10,1 do
        items[#items+1] = "FlameItem"
        items[#items+1] = "BombItem"
        items[#items+1] = "SpeedItem"
    end
    for i=1,2,1 do
        items[#items+1] = "KickItem"
    end
    items[#items+1] = "MegaFlameItem"

    local index = 1
    local nbBloc = 150

    while nbBloc ~= 0 do
        local elementsIndex = math.random(#emptySpace)
        local coord = table.remove(emptySpace,elementsIndex)
        local i = coord[1]
        local j = coord[2]

        if index <= #items then
            self.worldTable[i][j] = {BreakableBlock(i,j,1,items[index])}
            print(items[index])
            index += 1
        else
            self.worldTable[i][j] = {BreakableBlock(i,j,1)}
        end
        nbBloc -= 1
    end

    for index = 1, #emptySpace,1 do
        local i = emptySpace[index][1]
        local j = emptySpace[index][2]
        
        local block = self.worldTable[i][j-1]
        local shadow = false

        if(block ~= nil) then
            if block:isa(UnbreakableBlock) or block:isa(BreakableBlock) then
                shadow = true
            end
        end
        self.worldTable[i][j] = {Floor(i,j,1,shadow)}
    end

    local sound = playdate.sound.sampleplayer
    self.backgroundMusic = sound.new('sounds/SBomb1-Battle.wav')
    self.stageIntro = sound.new('sounds/Stage Intro.wav')


    self.backgroundMusic:setVolume(0.3)
    self.stageIntro:play(1,1)
    self.playatend = true
    self.stageIntro:setFinishCallback(function ()
        if self.playatend == true then
            self.backgroundMusic:play(0,1)
        end
        
    end)
    local menu = playdate.getSystemMenu()

    self.menuItem = menu:addMenuItem("Title Screen",function ()
        Noble.transition(MenuScene, 0.5, Noble.TransitionType.SLIDE_OFF_RIGHT)
    end)
end

function WorldScene:endGame(isWinning)
    gameGlobalVariables.isWinning = isWinning
    Noble.transition(EndScene, 0.5, Noble.TransitionType.SLIDE_OFF_LEFT)
end

function WorldScene:exit()
	WorldScene.super.exit(self)
	
    self.stageIntro:stop()
    self.playatend = false
    self.backgroundMusic:stop()

    local menu = playdate.getSystemMenu()
    menu:removeMenuItem(self.menuItem)
end