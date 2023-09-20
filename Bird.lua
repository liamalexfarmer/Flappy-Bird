--defines the class
Bird = Class{}

--variable for gravity acceleration
local GRAVITY = 20

--initialized variables for the bird class
function Bird:init()
	--calls upon the image file, and defines (w,h) using image parameters
	self.image = love.graphics.newImage('sprites/bird.png')
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()


	--positions the bird in the middle of the screen
	self.x = (VIRTUAL_WIDTH / 2) - (self.width / 2)
	self.y = (VIRTUAL_HEIGHT / 2) - (self.height / 2)

	--allows acceleration on the y axis
	self.dy = 0
end

function Bird:collides(pipe)
	if (self.x + self.width - 2) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
		if (self.y + self.height - 2) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
			return true
		end
	end

	return false
end

--how the bird behaves over time
function Bird:update(dt)
	--enables the bird to constantly accelerate over time based on gravity
		self.dy = self.dy + GRAVITY * dt

	--performs a jump if spacebard was pressed--makes it momentary
		if love.keyboard.wasPressed('space') then
			self.dy = -GRAVITY/4
		end

	--injects our y axis acceleration parameters into the birds y positioning
		self.y = self.y + self.dy
end

--renders the bird based on it's defined parameters
function Bird:render()
	love.graphics.draw(self.image, self.x, self.y)
end


