--introducing basestate variables and alias filtering
ScoreState = Class{__includes = BaseState}
love.graphics.setDefaultFilter("nearest", "nearest")

--creates a table of medals & graphics for easy recall
local medals = {
	['gold'] = love.graphics.newImage('sprites/goldmedal.png'),
	['silver'] = love.graphics.newImage('sprites/silvermedal.png'),
	['bronze'] = love.graphics.newImage('sprites/bronzemedal.png')
}

--defining some local variables to establish medal threshholds and sprite widths for alignment purposes
local MEDAL_WIDTH = medals.gold:getWidth()
local BRONZE_SCORE = 5
local SILVER_SCORE = 10
local GOLD_SCORE = 15

--what happens when you enter the score state
function ScoreState:enter(params)
	--receives the score parameter passed on from the previous game state
	--and attaches it to a local variable
	self.score = params.score
	
	--logic that gives a value to self.award based on score vs medal threshholds defined above
	--allows you to change thresholds easily without repeatedly re-writing code
	--and provides easy adjustable difficulty implementation down the road
	if self.score >= BRONZE_SCORE and self.score < SILVER_SCORE then
		self.award = medals.bronze
	elseif self.score >= SILVER_SCORE and self.score < GOLD_SCORE then
		self.award = medals.silver
	elseif self.score >= GOLD_SCORE then
		self.award = medals.gold
	else 
		self.award = nil
	end
end

--allows user to exit the score state and enter the countdown state
function ScoreState:update(dt)
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		gStateMachine:change('countdown')
	end
end



function ScoreState:render()
	--moved this lower so the win/loss message becomes interchangeable rather than both present
	--love.graphics.setFont(flappyFont)
	--love.graphics.printf("You said you wouldn't lose...CAP!", 0, VIRTUAL_HEIGHT/5, VIRTUAL_WIDTH, 'center')

	love.graphics.setFont(mediumFont)
	love.graphics.printf('Score: ' .. tostring(self.score), 0, VIRTUAL_HEIGHT/3, VIRTUAL_WIDTH, 'center')

	love.graphics.printf('Press Enter to Play Again', 0, 5 * VIRTUAL_HEIGHT/6, VIRTUAL_WIDTH, 'center')

		--celebrate the earning of a medal
	if self.award ~= nil then
		love.graphics.setFont(flappyFont)
		love.graphics.printf("YOU EARNED A MEDAL!", 0, VIRTUAL_HEIGHT/5, VIRTUAL_WIDTH, 'center')
		love.graphics.draw(self.award, (VIRTUAL_WIDTH / 2) - (MEDAL_WIDTH / 2), VIRTUAL_HEIGHT / 2)
	else
		--smack talking the player if they don't earn a medal for cappin'
		love.graphics.setFont(flappyFont)
		love.graphics.printf("You said you wouldn't lose...CAP!", 0, VIRTUAL_HEIGHT/5, VIRTUAL_WIDTH, 'center')
	end
end
	