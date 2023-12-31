--calling the push engine
push = require 'push'
--enabling the usage of class
Class = require 'class'

--requiring the various classes that comprise the game
require 'Bird'

require 'Pipe'

require 'PipePair'

require 'StateMachine'

require 'states/BaseState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'
require 'states/CountdownState'
require 'states/PauseState'

--setting and scaling dimentions of the game window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288


--setting the background image, and defining the pixel value that defines where it loops
local background = love.graphics.newImage('sprites/background.png')
local backgroundScroll = 0
local BACKGROUND_LOOPING_POINT = 413


--requires no looping point
local ground = love.graphics.newImage('sprites/ground.png')
local groundScroll = 0

--creating a parallax effect between the ground and the background
--using a constant SCROLL_SPEED
local SCROLL_SPEED = 60
local backgroundscrollSpeed = SCROLL_SPEED/2
local groundscrollSpeed = SCROLL_SPEED

--creating a local bird value based on the bird class
local bird = Bird()

paused = false




--establishing graphis formats, windo titles and screen setup parameters
function love.load()
	math.randomseed(os.time())

	--alias filters and window title
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.window.setTitle("No-Cappy Byrd")

	--initialize fonts
	smallFont = love.graphics.newFont('fonts/font.ttf', 8)
	mediumFont = love.graphics.newFont('fonts/flappy.ttf', 14)
	flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
	hugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)
	love.graphics.setFont(flappyFont)


	--some push setup options marrying the virtual & physical widths
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = false,
		resizable = true
	})

	--initialize sounds
	sounds = {
		['oneTwo'] = love.audio.newSource('sounds/1-2.wav', 'static'),
		['three'] = love.audio.newSource('sounds/3.wav', 'static'),
		['groundCollide'] = love.audio.newSource('sounds/GroundCollide.wav', 'static'),
		['pause'] = love.audio.newSource('sounds/Pause.wav', 'static'),
		['pipeCollide'] = love.audio.newSource('sounds/PipeCollide.wav', 'static'),
		['resume'] = love.audio.newSource('sounds/Resume.wav', 'static'),
		['sadBird'] = love.audio.newSource('sounds/SadBird.wav', 'static'),
		['score'] = love.audio.newSource('sounds/Score.wav', 'static'),
		['thud'] = love.audio.newSource('sounds/Thud.wav', 'static'),
		['bronze'] = love.audio.newSource('sounds/bronze.mp3', 'static'),
		['silver'] = love.audio.newSource('sounds/silver.mp3', 'static'),
		['gold'] = love.audio.newSource('sounds/gold.mp3', 'static'),
		['music'] = love.audio.newSource('sounds/8bitmusic.mp3', 'static')
	}

	--start & loop the background music
	sounds.music:setLooping(true)
	sounds.music:setVolume(0.5)
	sounds.music:play()

	--catalogging the different states our state machine will navigate
	gStateMachine = StateMachine {
		['title'] = function() return TitleScreenState() end,
		['countdown'] = function() return CountdownState() end,
		['play'] = function() return PlayState() end,
		['score'] = function() return ScoreState() end,
		['pause'] = function() return PauseState() end
	}
	gStateMachine:change('title')

	--creating a table of pressed keys
	love.keyboard.keysPressed = {}
end


--allows window resizing
function love.resize(w, h)
	push:resize(w, h)
end

--exit functionality
function love.keypressed(key)
	love.keyboard.keysPressed[key] = true
	if key == 'escape' then
		love.event.quit()
	end
end

--creates a boolean response based on keys pressed
function love.keyboard.wasPressed(key)
	if love.keyboard.keysPressed[key] then
		return true
	else
		return false
	end
end

--defines our games behavior over time
function love.update(dt)
		--only scrolls when the game isn't in the pause state
		if paused == false then
		--creates a moving X value for the background image that allows it to scroll over time
		--modulo resets the X value close to 0 for continuous scrolling
		backgroundScroll = (backgroundScroll + backgroundscrollSpeed * dt)
		% BACKGROUND_LOOPING_POINT

		--same principle as above but using the virtual width as a mechanism to reset the x point.
		groundScroll = (groundScroll + groundscrollSpeed * dt)
		% VIRTUAL_WIDTH
		end


	--update gamestate machine
		gStateMachine:update(dt)

	--flushes the keys pressed table on update
	love.keyboard.keysPressed = {}


end

--graphics drawing functions
function love.draw()
	--required for push utilization
	push:start()

	--draws background, calling upon moving variables defined above to enable scrolling
	love.graphics.draw(background, -backgroundScroll, 0)

	--defers render functions to state machine
	gStateMachine:render()

	--draws background, calling upon variables  calculated above to enable scrolling
	love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT-16)

	push:finish()
end