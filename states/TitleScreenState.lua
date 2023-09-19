TitleScreenState = Class{__includes = BaseState}

--logic that allows the state machine to enter the playstate
function TitleScreenState:update(dt)
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		gStateMachine:change('play')
	end
end

--displays on-screen prompts until user enters play state
function TitleScreenState:render()
	love.graphics.setFont(flappyFont)
	love.graphics.printf('No Cappy Byrd', 0, 64, VIRTUAL_WIDTH, 'center')

	love.graphics.setFont(mediumFont)
	love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')
end
