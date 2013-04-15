require('message')
function love.load()
	
	msg=message:new()
	--"ln" "wd"
	msg:add{msg={"hello\n欢迎来到我的博客\n希望和大家一同进步",
	"有问题可以给我留言，一同讨论"},mode="ln",fun=function() print("msg is over") end} 
	
	
end
function love.draw()
	
	loveframes.draw()
	msg:draw()
	
end
function love.update(dt)
loveframes.update()
msg:update(dt)
end
function love.mousepressed(x, y, button)
	loveframes.mousepressed(x, y, button)
end
function love.mousereleased(x, y, button)
	loveframes.mousereleased(x, y, button)
end
function love.keypressed(key, unicode)
	
	
	msg:keypressed(key,unicode)
	loveframes.keypressed(key, unicode)
	
end
function love.keyreleased(key)
	
	loveframes.keyreleased(key)
end
