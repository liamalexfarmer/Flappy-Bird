StateMachine = Class{}


--creates series of functions that allow the state machine to define operation functions
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
--for my future reference:
--brilliance of this machine is that you can define an exit function when LEAVING a specific state
--you then RE-DEFINE the state to the state initiated by the state change
--you then also have an entrance function when ARRIVING at a state
--sequence defined here is essentially:
--CARRY OUT CURRENT STATE EXIT FUNCTION -> SWITCH TO NEW SPECIFIED STATE -> CARRY OUT NEW STATE ENTER FUNCTION
function StateMachine:change(stateName, enterParams)
	assert(self.states[stateName]) -- checks to see whether the state exists
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
