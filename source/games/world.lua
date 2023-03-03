import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "Plugins/AnimatedSprite/AnimatedSprite.lua"
import "games/unbreakableBlock.lua"
import "games/utils.lua"
import "games/floor.lua"
import "games/Bomb.lua"
import "games/breakableBlock.lua"

local gfx <const> = playdate.graphics

class('World').extends()

function World:addBomb(i,j, power)
    local bomb = Bomb(i,j,power)
    bomb:add()
end


function World:init()
    math.randomseed(playdate.getSecondsSinceEpoch())
    self.worldTable = {}
    self.objectInWorld = {}

    for i = 1, 25, 1 do
        self.worldTable[i] = {}
        self.worldTable[i][1] = UnbreakableBlock( i, 1, 1)
        self.worldTable[i][15] = UnbreakableBlock( i, 15, 1)
    end

    for i = 3, 23, 2 do
        for j = 3, 13, 2 do
            self.worldTable[i][j] = UnbreakableBlock(i, j, 1)
        end
    end

    for j = 2, 14, 1 do
        self.worldTable[1][j] = UnbreakableBlock(1, j, 1)
        self.worldTable[25][j] = UnbreakableBlock(25, j, 1)
    end

    local emptySpace = {}
    local emptySpaceIndex = 1

    self.worldTable[2][2] = Floor(2,2,1,true)
    self.worldTable[3][2] = Floor(3,2,1,true)
    self.worldTable[2][3] = Floor(2,3,1,false)

    self.worldTable[24][14] = Floor(24,14,1,false)
    self.worldTable[24][13] = Floor(24,13,1,false)
    self.worldTable[23][14] = Floor(23,14,1,true)

    for i = 1, 25, 1 do
        for j = 1, 15, 1 do
            if self.worldTable[i][j] ~= nil then
                self.worldTable[i][j]:add()
            else
                emptySpace[emptySpaceIndex] = {i,j}
                emptySpaceIndex += 1
            end
        end
    end

    local nbBloc = 100
    while nbBloc ~= 0 do
        local elementsIndex = math.random(#emptySpace)
        local coord = table.remove(emptySpace,elementsIndex)
        local i = coord[1]
        local j = coord[2]
        self.worldTable[i][j] = BreakableBlock(i,j,1)
        self.worldTable[i][j]:add()
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
        
        self.worldTable[i][j] = Floor(i,j,1,shadow)
        self.worldTable[i][j]:add()
    end
end

world = World()