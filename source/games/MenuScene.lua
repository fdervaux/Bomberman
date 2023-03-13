MenuScene = {}
class("MenuScene").extends(NobleScene)

MenuScene.baseColor = Graphics.kColorWhite

local menu
local sequence

function MenuScene:init()
	MenuScene.super.init(self)

	menu = Noble.Menu.new(false, Noble.Text.ALIGN_CENTER, false, Graphics.kColorWhite, 4, 6, 0, Noble.Text.FONT_SMALL)

	menu:addItem('Ⓐ Start Game', function() Noble.transition(World, 0.5, Noble.TransitionType.SLIDE_OFF_LEFT) end)

	MenuScene.inputHandler = {
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

function MenuScene:enter()
	MenuScene.super.enter(self)

	playdate.graphics.setBackgroundColor(playdate.graphics.kColorWhite)

	sequence = Sequence.new():from(0):to(180, 1, Ease.outBounce)
	sequence:start();

	local sound = playdate.sound.sampleplayer
	self.backgroundMusic = sound.new('sounds/Title Screen.wav')
	self.backgroundMusic:setVolume(0.6)
	self.backgroundMusic:play(0, 1)

	self.background = NobleSprite("images/background2")

	self.background:add()
	self.background:moveTo(200, 120)
end

function MenuScene:start()
	MenuScene.super.start(self)

	menu:activate()
end

function MenuScene:drawBackground()
	MenuScene.super.drawBackground(self)
	--background:draw(0, 0)
end

function MenuScene:update()
	MenuScene.super.update(self)

	--Graphics.setColor(Graphics.kColorBlack)
	--Graphics.fillRoundRect(15, (sequence:get()*0.75)+3, 185, 145, 15)

	menu:draw(200, sequence:get())
end

function MenuScene:exit()
	MenuScene.super.exit(self)
	sequence = Sequence.new():from(180):to(0, 0.25, Ease.inOutCubic)
	sequence:start();
	self.backgroundMusic:stop()
end

function MenuScene:finish()
	MenuScene.super.finish(self)
end
