PlayState = Class{__includes = BaseState}

PIPE_SCROLL = -60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24


--initiate variables and tables to establish functionality
function PlayState:init()
	self.bird = Bird()
	self.pipePairs = {}
	self.timer = 0

	self.lastY = -PIPE_HEIGHT + math.random(80) + 20

	self.score = 0

	--since there is a countdown, create pipes immediately rather than waiting 3 seconds using -1
	timerCount = -1
end

function PlayState:enter(params)
	--resumes the parralax scrolling by re-establishing a non-paused state
	paused = false

	--sets the timer to -1 so a pipe spawns immediately as the play state enters

	--only passes parameters if they exist, otherwise ignores these instructions
	--added this since starting the game for the first time was throwing an error
	--because this variable transfer is only relevant when changing FROM pause TO play states
	--and NOT when changing from countdown to play state for example
	if params ~= nil then
		self.bird = params.bird
		self.pipePairs = params.pipePairs
		self.timer = params.timer

		self.lastY = params.lastY

		self.score = params.score
	end
end

function PlayState:update(dt)

	--pipe interval mechanism
	self.timer = self.timer + dt

	--uses a timerCount varible for randomized distances
	--also leverages arithmetic to add limited randomization to pipe heights
	--subtraction of 150 is maximum gap height (120) + 30 pixel cushion to prevent off-screen bottom pipes
	if self.timer > timerCount then
		local y = math.max(-PIPE_HEIGHT + 30, 
			math.min(self.lastY + math.random(-50, 50), VIRTUAL_HEIGHT - PIPE_HEIGHT - 150))
		self.lastY = y

		--adds a pair of pipes to the PipePairs table
		table.insert(self.pipePairs, PipePair(y))

		--resets the count to zero, and then creates a new whole number between 2 and 4 to be the new interval distance
		self.timer = 0
		timerCount = math.max(math.random(2, 4))
	end

	--scoring mechanism for passing pipes
	--avoids excess processing by establishing a pair.scored 
	for k, pair in pairs(self.pipePairs) do
		if not pair.scored then
			if pair.x + PIPE_WIDTH < self.bird.x then
				self.score = self.score + 1
				--play the score sound every time a score is registered
				sounds.score:play()
				pair.scored = true
			end
		end
		--updates the pipe class (x position essentially)
		pair:update(dt)
	end

	--removes any off-screen pipes from the table
	for k, pair in pairs(self.pipePairs) do
		if pair.remove then
			table.remove(self.pipePairs, k)
		end
	end


	--updates the birds position
	self.bird:update(dt)

	--collision arithmetic defined in bird class
	--pass through score variable on state change
	for k, pair in pairs(self.pipePairs) do
		for l, pipe in pairs(pair.pipes) do
			if self.bird:collides(pipe) then
				--collection of sounds that plays on a pipe collision
				sounds.pipeCollide:play()
				sounds.sadBird:play()
				sounds.thud:play()

				gStateMachine:change('score', {
					score = self.score
				})
				
			end
		end
	end

	--death by hitting the ground
	if self.bird.y + BIRD_HEIGHT > VIRTUAL_HEIGHT - 15 then
		--collection of sounds that play on a ground collision. same as pipe save for 1 sound
		sounds.groundCollide:play()
		sounds.sadBird:play()
		sounds.thud:play()

		gStateMachine:change('score', {
			score = self.score
		})
	end


	--pause state change, passing off game-state variables
	--so you can pick up where you left off
	--otherwise the game resets
	if love.keyboard.wasPressed('p') then
		gStateMachine:change('pause', {
			bird = self.bird,
			pipePairs = self.pipePairs,
			timer = self.timer,
			lastY = self.lastY,
			score = self.score
		})
	end

end

	--render pipes, graphics, score, etc
function PlayState:render()
	for k, pair in pairs(self.pipePairs) do
		pair:render()
	end

	love.graphics.setFont(flappyFont)
	love.graphics.print('Score: '.. tostring(self.score), 8, 8)

	self.bird:render()
end

