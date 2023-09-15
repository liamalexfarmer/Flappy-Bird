--define pipe as a class
Pipe = Class{}

--defining an image as a value/reference to only have to store one image 
local PIPE_IMAGE = love.graphics.newImage('sprites/pipe.png')

--define a scroll speed
local PIPE_SCROLL = -60

--
function Pipe:init()
	--sets it's x position to just outside the right most edge of the screen
	self.x = VIRTUAL_WIDTH + 1

	--sets is y position to a random point between two limits
	self.y = math.random(VIRTUAL_HEIGHT * 3 / 8, VIRTUAL_HEIGHT * 6 / 8)

	--defines the pipe width by the image width
	self.width = PIPE_IMAGE:getWidth()

end

	--apply an update function to allow the pop to scroll
function Pipe:update(dt)
	self.x = self.x + PIPE_SCROLL * dt
end

--render the pipe and apply it's positional property
function Pipe:render()
	love.graphics.draw(PIPE_IMAGE, self.x, self.y)
end
