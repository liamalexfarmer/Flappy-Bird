--calling the push engine
push = require 'push'
--enabling the usage of class
Class = require 'class'

--requiring the bird class
require 'Bird'

require 'Pipe'

--setting and scaling dimentions of the game window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288


--setting the background image, and defining the pixel value that separates it's loopability
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

local pipes = {}

local spawnTimer = 0


--establishing graphis formats, windo titles and screen setup parameters
function love.load()
	math.randomseed(os.time())

	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.window.setTitle("No-Cappy Byrd")

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = false,
		resizable = true
	})

	--creating a table of pressed keys
	love.keyboard.keysPressed = {}
end


--allows window resizing
function love.resize(w,h)
	push:resize(w, h)
end

--
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
	--creates a moving X value for the background image that allows it to scroll over time
	--modulo resets the X value close to 0 for continuous scrolling
	backgroundScroll = (backgroundScroll + backgroundscrollSpeed * dt)
	% BACKGROUND_LOOPING_POINT

	--same principle as above but using the virtual width as a mechanism to reset the x point.
	groundScroll = (groundScroll + groundscrollSpeed * dt)
	% VIRTUAL_WIDTH

	--define logic that creates a spawn timer counter
	spawnTimer = spawnTimer + dt

	--once 2 seconds elapses, create a pipe and reset the spawn timer
	if spawnTimer > 3 then
		table.insert(pipes, Pipe())
		spawnTimer = 0
	end

	--executes the update functions defined in bird class
	bird:update(dt)

	for k, pipe in pairs(pipes) do
		pipe:update(dt)

		if pipe.x < -pipe.width then
			table.remove(pipes, k)
		end
	end
	--flushes the keys pressed table on update
	love.keyboard.keysPressed = {}
end

--graphics drawing functions
function love.draw()
	--required for push utilization
	push:start()

	--draws background, calling upon moving variables defined above to enable scrolling
	love.graphics.draw(background, -backgroundScroll, 0)

	--renders all pipes that exist in pipes table
	for k, pipe in pairs(pipes) do
		pipe:render()
	end


	--draws background, calling upon variables  calculated above to enable scrolling
	love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT-16)

	--renders our bird on screen based on class parameters.
	bird:render()

	push:finish()
end