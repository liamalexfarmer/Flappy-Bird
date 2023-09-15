push = require 'push'

Class = require 'class'

require 'Bird'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('sprites/background.png')
local backgroundScroll = 0
local BACKGROUND_LOOPING_POINT = 413

local ground = love.graphics.newImage('sprites/ground.png')
local groundScroll = 0

local SCROLL_SPEED = 60
local backgroundscrollSpeed = SCROLL_SPEED/2
local groundscrollSpeed = SCROLL_SPEED

local bird = Bird()


function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.window.setTitle("No-Cappy Byrd")

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = false,
		resizable = true
	})
end

function love.resize(w,h)
	push:resize(w, h)
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end

function love.update(dt)
	backgroundScroll = (backgroundScroll + backgroundscrollSpeed * dt)
	% BACKGROUND_LOOPING_POINT

	groundScroll = (groundScroll + groundscrollSpeed * dt)
	% VIRTUAL_WIDTH
end


function love.draw()
	push:start()

	love.graphics.draw(background, -backgroundScroll, 0)
	love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT-16)

	bird:render()

	push:finish()
end