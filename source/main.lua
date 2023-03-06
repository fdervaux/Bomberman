import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "libraries/noble/Noble"
import "libraries/animatedSprite/AnimatedSprite.lua"
import "games/world.lua"
import "games/player.lua"
import "games/shaker.lua"


local gfx <const> = playdate.graphics

Noble.new(LevelScene)

world = World()
player1 = Player(2, 2, P1)
player2 = Player(24, 14, p2)

function playdate.AButtonDown()
	print("dropBomb")
	player1:dropBomb()
	-- player2:dropBomb()
end

function playdate.update()
	local playerdirection = playdate.geometry.vector2D.new(0, 0)

	if playdate.buttonIsPressed(playdate.kButtonUp) then
		playerdirection.y = -1
	end
	if playdate.buttonIsPressed(playdate.kButtonRight) then
		playerdirection.x = 1
	end
	if playdate.buttonIsPressed(playdate.kButtonDown) then
		playerdirection.y = 1
	end
	if playdate.buttonIsPressed(playdate.kButtonLeft) then
		playerdirection.x = -1
	end

	player1:Move(playerdirection)
	-- player2:Move(playerdirection)

	playdate.graphics.sprite.update()
	playdate.timer.updateTimers()
end
