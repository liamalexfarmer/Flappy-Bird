PauseState = Class{__includes = BaseState}

--logic that allows the state machine to enter the playstate

function PauseState:enter(params)
	self.bird = params.bird
	self.pipePairs = params.pipePairs
	self.timer = params.timer
	self.lastY = params.lastY
	self.score = params.score
	
end


function PauseState:update(dt)
	paused = true
	if love.keyboard.wasPressed('r') then
		gStateMachine:change('play', {
			bird = self.bird,
			pipePairs = self.pipePairs,
			timer = self.timer,
			lastY = self.lastY,
			score = self.score
		})
	end
end

--displays on-screen prompts until user enters play state
function PauseState:render()
		
	for k, pair in pairs(self.pipePairs) do
		pair:render()
	end

	love.graphics.setFont(flappyFont)
	love.graphics.print('Score: '.. tostring(self.score), 8, 8)

	self.bird:render()

	love.graphics.setFont(hugeFont)
	love.graphics.printf('GAME PAUSED', 0, VIRTUAL_HEIGHT/4, VIRTUAL_WIDTH, 'center')

	love.graphics.setFont(mediumFont)
	love.graphics.printf('Press R to Resume', 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'center')
end
