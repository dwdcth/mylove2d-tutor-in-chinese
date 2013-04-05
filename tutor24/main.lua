require'role'
require 'gmworld'


function love.load()
	xiaoxiao=role:new()
	xiaoxiao:create("ball.png","ball",400,500)
	xiaoxiao:setJumpForce()
	
	xh=role:new()
	xh:create("ball.png","hhh",400,350,"wall")
	xh:setJumpForce()
	
	myworld=gmworld:new()
	myworld:create()
	myworld:addRole(xiaoxiao)
	myworld:addRole(xh)
	
end

function love.update(dt)
	
	myworld:update(dt)
end

function love.draw()
myworld:draw()
end


