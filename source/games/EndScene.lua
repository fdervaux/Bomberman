EndScene = {}
class("EndScene").extends(NobleScene)

EndScene.baseColor = Graphics.kColorWhite

local menu
local sequence

function EndScene:init()
	EndScene.super.init(self)

	menu = Noble.Menu.new(false, Noble.Text.ALIGN_CENTER, false, Graphics.kColorWhite, 4, 20, 0, Noble.Text.FONT_SMALL)
	menu:addItem('Start Game', function() Noble.transition(WorldScene, 0.5, Noble.TransitionType.SLIDE_OFF_RIGHT) end)
	menu:addItem('Title screen', function() Noble.transition(MenuScene, 0.5, Noble.TransitionType.SLIDE_OFF_RIGHT) end)

	EndScene.inputHandler = {
		upButtonDown = function()
			menu:selectPrevious()
		end,
		downButtonDown = function()
			menu:selectNext()
		end,
		AButtonDown = function()
			menu:click()
		end
	}
end

function EndScene:enter()
	EndScene.super.enter(self)

	playdate.graphics.setBackgroundColor(playdate.graphics.kColorWhite)

	sequence = Sequence.new():from(0):to(180, 1, Ease.outBounce)
	sequence:start();

	local sound = playdate.sound.sampleplayer
	self.backgroundMusic = sound.new('sounds/Title Screen.wav')
	self.backgroundMusic:setVolume(0.6)
	self.backgroundMusic:play(0, 1)

	print(gameGlobalVariables.isWinning)

	if gameGlobalVariables.isWinning then
		self.background = NobleSprite("images/You Win")
	else
		self.background = NobleSprite("images/Game Over")
	end

	self.background:add()
	self.background:moveTo(200, 120)
end

function EndScene:start()
	EndScene.super.start(self)

	menu:activate()
end

function EndScene:drawBackground()
	EndScene.super.drawBackground(self)
	--background:draw(0, 0)
end

function EndScene:update()
	EndScene.super.update(self)

	--Graphics.setColor(Graphics.kColorBlack)
	--Graphics.fillRoundRect(15, (sequence:get()*0.75)+3, 185, 145, 15)

	menu:draw(200, sequence:get())
end

function EndScene:exit()
	EndScene.super.exit(self)
	sequence = Sequence.new():from(180):to(0, 0.25, Ease.inOutCubic)
	sequence:start();
	self.backgroundMusic:stop()
end

function EndScene:finish()
	EndScene.super.finish(self)
end
