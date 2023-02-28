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

	local backgroundImage = gfx.image.new("images/background")
	gfx.sprite.setBackgroundDrawingCallback(
		function(x, y, width, height)
			gfx.setClipRect(x, y, width, height)
			backgroundImage:draw(0, 0)
			gfx.clearClipRect()
		end
	)

	local coinImage = gfx.image.new("images/coin")
    coinSprite = gfx.sprite.new(coinImage)
	moveCoin()
	coinSprite:setCollideRect(0, 0, coinSprite:getSize())
	coinSprite:add()

	local playerImage = gfx.image.new("images/player")
	local imagetable = playdate.graphics.imagetable.new('images/character-table-32-32.png')

	playerAnimatedSprite = AnimatedSprite.new(imagetable)

	local p1 = 0
	local p2 = 5
	local playerShift = p2
	local speed = 10

	playerAnimatedSprite:addState('p1IdleUp',1+playerShift,1+playerShift,{ tickStep = 10 })
	playerAnimatedSprite:addState('p1RunUp',1,3,{ tickStep = speed, yoyo = true, frames = {2+playerShift,1+playerShift,3+playerShift} })
	
	playerAnimatedSprite:addState('p1IdleRight',10+playerShift,10+playerShift,{ tickStep = 10 })
	playerAnimatedSprite:addState('p1RunRight',1,3,{ tickStep = speed, yoyo = true, frames = {11+playerShift,10+playerShift,12+playerShift} })
	
	playerAnimatedSprite:addState('p1IdleDown',19+playerShift,19+playerShift,{ tickStep = 10 }).asDefault()
	playerAnimatedSprite:addState('p1RunDown',1,3,{ tickStep = speed, yoyo = true, frames = {20+playerShift,19+playerShift,21+playerShift} })
	
	playerAnimatedSprite:addState('p1IdleLeft',28+playerShift,28+playerShift,{ tickStep = 10 })
	playerAnimatedSprite:addState('p1RunLeft',1,3,{ tickStep = speed, yoyo = true, frames = {29+playerShift,28+playerShift,30+playerShift} })

	-- playerSprite = gfx.sprite.new(playerImage)
	playerAnimatedSprite:moveTo(200, 120)
	-- playerAnimatedSprite:setCollideRect(8, 8, 16, 16)
	playerAnimatedSprite:playAnimation()
	playerAnimatedSprite:setZIndex(1)


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