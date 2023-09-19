--define pipe as a class
Pipe = Class{}

--defining an image as a value/reference to only have to store one image 
local PIPE_IMAGE = love.graphics.newImage('sprites/pipe.png')

--define a scroll speed
PIPE_SCROLL = -60

PIPE_HEIGHT = 288
PIPE_WIDTH = 70

--
function Pipe:init(orientation, y)
	--sets it's x position to just outside the right most edge of the screen
	self.x = VIRTUAL_WIDTH

	--sets its y position to a random point between two limits
	self.y = y

	--defines the pipe width by the image width
	self.width = PIPE_IMAGE:getWidth()
	self.height = PIPE_HEIGHT

	self.orientation = orientation

end

	--apply an update function to allow the pop to scroll
function Pipe:update(dt)

end

--render the pipe and apply it's positional property
--for reference: this syntax: self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y 
--basically means: IF self.orientation == 'top' then return self.y + PIPE_HEIGHT otherwise use self.y
--useful technique to remember because it's not obvious
--expectation would be an if/else sequence, but this almost functions as a short hand.
function Pipe:render()
	--love.graphics.draw(drawable, x, y, rotation, scale x, scale y)
	love.graphics.draw(PIPE_IMAGE, self.x, 
		(self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 
		0, 1, self.orientation == 'top' and -1 or 1)
		--this is the y scale factor. setting scale to -1 flips the orientation of a sprite
end
