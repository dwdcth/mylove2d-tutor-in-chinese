require('BoundBox')
function love.load()
	
	local	img1=love.graphics.newImage("assets/box1.png")
	local	img2=love.graphics.newImage("assets/box2.png")
	local	imgs={}
	imgs[1]=img1
	for i=2,18 do
		imgs[i]=img2
	end
	--(rows,cols,resw,resh,imgs)
	bouBox=BoundBox:new(3,6,98,98,imgs)
end

function love.update(dt)
			
	bouBox:update(dt)
	loveframes.update(dt)

end
				
function love.draw()

	bouBox:draw()
	loveframes.draw()

end

function love.mousepressed(x, y, button)


	loveframes.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)


	loveframes.mousereleased(x, y, button)

end

function love.keypressed(key, unicode)


	loveframes.keypressed(key, unicode)

end

function love.keyreleased(key)


	loveframes.keyreleased(key)

end