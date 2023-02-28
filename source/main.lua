import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "Plugins/AnimatedSprite/AnimatedSprite.lua"

local gfx <const> = playdate.graphics

local playerAnimatedSprite = nil

local playerSpeed = 4

local playTimer = nil
local playTime = 30 * 1000

local coinSprite = nil
local score = 0

local lastDirection = ""

local function resetTimer()
	playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

local function moveCoin()
	local randX = math.random(40, 360)
	local randY = math.random(40, 200)
	coinSprite:moveTo(randX, randY)
end

local function initialize()
	math.randomseed(playdate.getSecondsSinceEpoch())
	local playerImage = gfx.image.new("images/player")
	local imagetable = playdate.graphics.imagetable.new('images/character-table-32-32.png')

	playerAnimatedSprite = AnimatedSprite.new(imagetable)
	playerAnimatedSprite:addState('p1IdleUp',1,1,{ tickStep = 10 })
	playerAnimatedSprite:addState('p1RunUp',2,3,{ tickStep = 10 })
	
	playerAnimatedSprite:addState('p1IdleRight',10,10,{ tickStep = 10 })
	playerAnimatedSprite:addState('p1RunRight',11,12,{ tickStep = 10 })
	
	playerAnimatedSprite:addState('p1IdleDown',19,19,{ tickStep = 10 }).asDefault()
	playerAnimatedSprite:addState('p1RunDown',20,21,{ tickStep = 10 })
	
	playerAnimatedSprite:addState('p1IdleLeft',28,28,{ tickStep = 10 })
	playerAnimatedSprite:addState('p1RunLeft',29,30,{ tickStep = 10 })

	-- playerSprite = gfx.sprite.new(playerImage)
	playerAnimatedSprite:moveTo(200, 120)
	playerAnimatedSprite:setCollideRect(8, 8, 16, 16)
	playerAnimatedSprite:playAnimation()


	local coinImage = gfx.image.new("images/coin")
    coinSprite = gfx.sprite.new(coinImage)
	moveCoin()
	coinSprite:setCollideRect(0, 0, coinSprite:getSize())
	coinSprite:add()

	local backgroundImage = gfx.image.new("images/background")
	gfx.sprite.setBackgroundDrawingCallback(
		function(x, y, width, height)
			gfx.setClipRect(x, y, width, height)
			backgroundImage:draw(0, 0)
			gfx.clearClipRect()
		end
	)

	imagetable = playdate.graphics.imagetable.new('images/Bomberman-Character.png')

	lastDirection = "Down"

	resetTimer()
end

initialize()

function playdate.update()
	
	if playTimer.value == 0 then
		if playdate.buttonJustPressed(playdate.kButtonA) then
			resetTimer()
			moveCoin()
			score = 0
		end
	else

		if playdate.buttonIsPressed(playdate.kButtonUp) then
			playerAnimatedSprite:forceNextAnimation(true,'p1RunUp')
			playerAnimatedSprite:moveBy(0, -playerSpeed)
			lastDirection = "Up"
		elseif playdate.buttonIsPressed(playdate.kButtonRight) then
			playerAnimatedSprite:forceNextAnimation(true,'p1RunRight')
			-- playerAnimatedSprite.changeState('p1runright',true)
			playerAnimatedSprite:moveBy(playerSpeed, 0)
			lastDirection = "Right"
		
		elseif playdate.buttonIsPressed(playdate.kButtonDown) then
			playerAnimatedSprite:forceNextAnimation(true,'p1RunDown')
			playerAnimatedSprite:moveBy(0, playerSpeed)
			lastDirection = "Down"
		
		elseif playdate.buttonIsPressed(playdate.kButtonLeft) then
			playerAnimatedSprite:forceNextAnimation(true,'p1RunLeft')
			playerAnimatedSprite:moveBy(-playerSpeed, 0)
			lastDirection = "Left"
		else
			playerAnimatedSprite:forceNextAnimation(true,'p1Idle' .. lastDirection)
		end

		-- print(playerAnimatedSprite.currentState)

		local collisions = coinSprite:overlappingSprites()
		if #collisions >= 1 then
			moveCoin()
			score += 1
		end

		playdate.graphics.sprite.update()
	end

	playdate.timer.updateTimers()
	gfx.sprite.update()

	gfx.drawText("Time: " .. math.ceil(playTimer.value/1000), 5, 5)
	gfx.drawText("Score: " .. score, 320, 5)
end