import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "libraries/noble/Noble"
import "libraries/animatedSprite/AnimatedSprite.lua"
import "games/utils.lua"
import "games/staticSprite.lua"
import "games/worldScene.lua"
import "games/MenuScene.lua"
import "games/EndScene.lua"
import "games/player.lua"
import "games/shaker.lua"
import "games/unbreakableBlock.lua"
import "games/floor.lua"
import "games/Bomb.lua"
import "games/breakableBlock.lua"
import "games/explosion.lua"

-- Noble.showFPS = true

gameGlobalVariables = 
{
	isWinning = false
}

Noble.new(MenuScene)