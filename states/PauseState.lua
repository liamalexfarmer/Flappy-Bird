PauseState = Class{__includes = BaseState}

--logic that allows the state machine to enter the playstate
function PauseState:update(dt)
	if love.keyboard.wasPressed('p') then
		gStateMachine:change('play')
	end
end

--displays on-screen prompts until user enters play state
function TitleScreenState:render()
	love.graphics.setFont(hugeFont)
	love.graphics.printf('GAME PAUSED', 0, 64, VIRTUAL_WIDTH, 'center')

	love.graphics.setFont(mediumFont)
	love.graphics.printf('Press P to Resume', 0, 100, VIRTUAL_WIDTH, 'center')
end
