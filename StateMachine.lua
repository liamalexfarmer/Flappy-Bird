StateMachine = Class{}


--creates series of functions that allow the state machine to operate
function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}
	self.states = states or {}
	self.current = self.empty
end

--defining some functions to carry out state changes and pass variables between states
function StateMachine:change(stateName, enterParams)
	assert(self.states[stateName]) -- state must exist
	self.current:exit()
	self.current = self.states[stateName]()
	self.current:enter(enterParams)
end

--applies updates and rendering based on state parameters
function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:render()
	self.current:render()
end
