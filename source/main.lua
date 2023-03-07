import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "libraries/noble/Noble"
import "libraries/animatedSprite/AnimatedSprite.lua"
import "games/worldScene.lua"
import "games/MenuScene.lua"
import "games/player.lua"
import "games/shaker.lua"


-- Noble.showFPS = true

Noble.new(MenuScene)



--[[function playdate.AButtonDown()
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

	--player1:Move(playerdirection)
	-- player2:Move(playerdirection)

	playdate.graphics.sprite.update()
	playdate.timer.updateTimers()
end]]--
