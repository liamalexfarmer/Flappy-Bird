PipePair = Class{}

--gap spacing between pipes
--local gapHeight = math.random(90, 120)

function PipePair:init(y)
	--establish position off-screen
	self.x = VIRTUAL_WIDTH + 32

	--set it's why to the passed value
	self.y = y

	--table defining both bottom and top pipes using string key
	--since sprites are anchored by the top left indice,
	--the top pipe must be offset by it's height to establish it's correct position
	--math.random provides gap height randomization between opposing pipes
	self.pipes = {
		['upper'] = Pipe('top', self.y),
		['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + math.random(90, 120))
	}
	--defining a pipe as not ready to be removed
	self.remove = false
	self.scored = false

	--gapHeight = math.random(90, 120)

end

function PipePair:update(dt)
	--scrolls the individual pipes in the self.pipes table based on the pipe scroll speed defined in pipe class
	--will carry out these movements so long as the pipe remains on the screen
	if self.x > -PIPE_WIDTH then
		self.x = self.x + PIPE_SCROLL * dt
		self.pipes['lower'].x = self.x
		self.pipes['upper'].x = self.x
	else
		--once the pipe moves off the screen signal main.lua to remove it using this boolean variable
		self.remove = true
	end
end

	--render all of the pipes present inside the self.pipes table
function PipePair:render()
	for k, pipe in pairs(self.pipes) do
		pipe:render()
	end
end
