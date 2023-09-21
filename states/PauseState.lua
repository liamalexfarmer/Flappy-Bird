PauseState = Class{__includes = BaseState}


--upon entering the pause state, pass important game state variables
--in order to maintain progress. game restarts otherwise
function PauseState:enter(params)
	self.bird = params.bird
	self.pipePairs = params.pipePairs
	self.timer = params.timer
	self.lastY = params.lastY
	self.score = params.score

	--plays a designated sound upon entering the pause state
	sounds.pause:play()
	sounds.music:pause()
end

--sets paused to true, which scrolling in main.lua uses to determine when to pause scrolling
--then carries out the opposite of above, feeding stored variables back into the play state
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

function PauseState:exit()
	--plays a resume sound when exiting the pause state
	sounds.resume:play()
	sounds.music:play()
end

--displays on-screen prompts until user enters play state
--also renders pipes/bird in their fixes positions passed on through the game state change
function PauseState:render()
	--render pipes	
	for k, pair in pairs(self.pipePairs) do
		pair:render()
	end

	--render score
	love.graphics.setFont(flappyFont)
	love.graphics.print('Score: '.. tostring(self.score), 8, 8)

	--render bird
	self.bird:render()

	--paused and resumed messages while paused
	love.graphics.setFont(hugeFont)
	love.graphics.printf('GAME PAUSED', 0, VIRTUAL_HEIGHT/4, VIRTUAL_WIDTH, 'center')

	love.graphics.setFont(mediumFont)
	love.graphics.printf('Press R to Resume', 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'center')
end
