tilemap=require('tilemap')
require('tutor4')
--地图在屏幕上显示的x，y坐标
mapX,mapY=100,100
quadtable={}

--那些注释是我试验坐标时用的，坐标不易确定啊
function love.load()
	image=love.graphics.newImage("assets/" .. tilemap["tilesets"][1].name ..tilemap["properties"]["format"])
	makeQuad(tilemap)
	
	--quad1=love.graphics.newQuad(1,1,32,32,265,199)
	--quad2=love.graphics.newQuad(34,1,32,32,265,199)
end



function love.draw()
	drawMap(tilemap,image)
	--love.graphics.drawq(image,quad1,100,100)
	--love.graphics.drawq(image,quad2,132,100)
end

function love.update(dt)
	--按键检测
	if(love.keyboard.isDown("up")) then
	mapY=mapY-20
	end
	if(love.keyboard.isDown("down")) then
	mapY=mapY+20
	end
	if(love.keyboard.isDown("left")) then
	mapX=mapX-20
	end
	if(love.keyboard.isDown("right")) then
	mapX=mapX+20
	end
	--边界检测省略

end

function love.keypressed(key)

end
