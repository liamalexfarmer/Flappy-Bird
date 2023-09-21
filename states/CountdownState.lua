CountdownState = Class{__includes = BaseState}

--sets the "count" interval in seconds...0.75 would be 3/4 of a second
--allows a faster 3, 2, 1 countdown if desired
COUNTDOWN_TIME = 1

--sets needed variables when the countdown state is entered
--count is how long in seconds before the game starts
--timer is used to count up to self.count
function CountdownState:init()
	self.count = 3
	self.timer = 0
	--plays a countdown sound on init (3)
	sounds.oneTwo:play()
end

--the countdown sequence
function CountdownState:update(dt)
	--add the time that's passed to the timer
	self.timer = self.timer + dt
	--checks self.timer against countdown time
	if self.timer > COUNTDOWN_TIME then
		--plays the countdown sound the same as above for (2) and (1)
		sounds.oneTwo:play()
		--if it reaches the countdown time, set it to zero effectively (remainder of countdown time / countdown time, which has no remainder)
		--obviously this whole sequence could be less cumbersome if countdown time was simply 1 second, but it's a nice feature
		self.timer = self.timer % COUNTDOWN_TIME
		--reduce the count by 1
		self.count = self.count - 1

		--if the count reaches zero, start the game
		if self.count == 0 then
			gStateMachine:change('play')
			--plays a slightly different countdown sound on 'GO' to signify the start of the game
			sounds.three:play()
		end
	end
end

--ensures we have a pipe spawn as soon as the countdown state transitions into the play state
function CountdownState:exit()
	timerCount = -1
end

--prints the countdown on the center of the screen in big font
function CountdownState:render()
	love.graphics.setFont(hugeFont)
	love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end
