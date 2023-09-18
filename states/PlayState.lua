PlayState = Class{__includes = BaseState}

PIPE_SCROLL = -60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
	self.bird = Bird()
	self.pipePairs = {}
	self.timer = 0

	self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
	self.timer = self.timer + dt

	if self.timer > 3 then
		local y = math.max(-PIPE_HEIGHT + 10, 
			math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
		self.lastY = y

		table.insert(self.pipePairs, PipePair(y))

		self.timer = 0
	end

	for k, pair in pairs(self.pipePairs) do
		pair:update(dt)
	end

	self.bird:update(dt)

	for k, pair in pairs(self.pipePairs) do
		for l, pipe in pairs(pair.pipes) do
			if self.bird:collides(pipe) then
				gStateMachine:change('title')
			end
		end
	end

	if self.bird.y + BIRD_HEIGHT > VIRTUAL_HEIGHT - 15 then
		gStateMachine:change('title')
	end

end

function PlayState:render()
	for k, pair in pairs(self.pipePairs) do
		pair:render()
	end

	self.bird:render()
end

