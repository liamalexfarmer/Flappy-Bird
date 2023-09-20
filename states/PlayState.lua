PlayState = Class{__includes = BaseState}

PIPE_SCROLL = -60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

--since we have a countdown, create pipes immediately rather than waiting 3 seconds
timerCount = -1

function PlayState:init()
	self.bird = Bird()
	self.pipePairs = {}
	self.timer = 0

	self.lastY = -PIPE_HEIGHT + math.random(80) + 20

	self.score = 0
end

function PlayState:enter(params)
	paused = false
	if params == nil then
		PlayState:init()
	else
		self.bird = params.bird
		self.pipePairs = params.pipePairs
		self.timer = params.timer

		self.lastY = params.lastY

		self.score = params.score
	end
end

function PlayState:update(dt)
	self.timer = self.timer + dt

	if self.timer > timerCount then
		local y = math.max(-PIPE_HEIGHT + 30, 
			math.min(self.lastY + math.random(-50, 50), VIRTUAL_HEIGHT - 30 - PIPE_HEIGHT))
		self.lastY = y

		table.insert(self.pipePairs, PipePair(y))

		self.timer = 0
		timerCount = math.max(math.random(2, 4))
	end

	for k, pair in pairs(self.pipePairs) do
		if not pair.scored then
			if pair.x + PIPE_WIDTH < self.bird.x then
				self.score = self.score + 1
				pair.scored = true
			end
		end

		pair:update(dt)
	end

	for k, pair in pairs(self.pipePairs) do
		if pair.remove then
			table.remove(self.pipePairs, k)
		end
	end


	self.bird:update(dt)

	for k, pair in pairs(self.pipePairs) do
		for l, pipe in pairs(pair.pipes) do
			if self.bird:collides(pipe) then
				gStateMachine:change('score', {
					score = self.score
				})
				timerCount = -1
			end
		end
	end

	if self.bird.y + BIRD_HEIGHT > VIRTUAL_HEIGHT - 15 then
		gStateMachine:change('score', {
			score = self.score
		})
	end

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

function PlayState:render()
	for k, pair in pairs(self.pipePairs) do
		pair:render()
	end

	love.graphics.setFont(flappyFont)
	love.graphics.print('Score: '.. tostring(self.score), 8, 8)

	self.bird:render()
end

