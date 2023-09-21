--defines the class
Bird = Class{}

--variable for gravity acceleration
local GRAVITY = 20

	--creating a table of different jump sounds to create random variation (missing numbers were discarded options)
	jumpSounds = {
		['jump'] = love.audio.newSource('sounds/jumps/Jump.wav', 'static'),
		['jump1'] = love.audio.newSource('sounds/jumps/Jump1.wav', 'static'),
		['jump2'] = love.audio.newSource('sounds/jumps/Jump2.wav', 'static'),
		['jump3'] = love.audio.newSource('sounds/jumps/Jump3.wav', 'static'),
		['jump6'] = love.audio.newSource('sounds/jumps/Jump6.wav', 'static'),
		['jump7'] = love.audio.newSource('sounds/jumps/Jump7.wav', 'static'),
		['jump8'] = love.audio.newSource('sounds/jumps/Jump8.wav', 'static')
	}


--this creates a new array providing numerical keys to the table above
--useful logic to remember/document
--call upon this later 
function convertArray(d)
	jumpsArray = { }
	for i, v in next, d do
		jumpsArray[#jumpsArray + 1] = v
	end
	return jumpsArray
end

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

	--creates an array self.jumps based on above defined function, where k = 1, 2, 3, etc and v = string & it's related sound
	self.jumps = convertArray(jumpSounds)
end

--function to signal that a collision has occured
--some leeway is built in around the bird for better user experience
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

				--since we provided key values, we can play sounds using self.jumps[x]:play
				--where x = k and the sound that plays is equivalent to a unique member of the jumpSounds table
				--#self.jumps pulls a numerical value of the number of fields in self.jumps, so replacing x with 
				--a random value between 1 and the number of SFX options to play a random jump sound each jump for variety
				self.jumps[math.random(#self.jumps)]:play()
		end

	--injects our y axis acceleration parameters into the birds y positioning
		self.y = self.y + self.dy
end

--renders the bird based on it's defined parameters
function Bird:render()
	love.graphics.draw(self.image, self.x, self.y)
end


