require('Button')

function testClick()
	love.graphics.setBackgroundColor(100,100,100)
end

function love.load()
	myBtn=Button:new("myBtn",100,100)
	myBtn:onClick( testClick) --回调函数
end

function love.update(dt)
	myBtn:update()
end

function love.draw()
	myBtn:draw()
end



