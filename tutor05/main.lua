tilemap=require('tilemap')
require('maptool')
require('camera')
--地图在屏幕上显示的左上角x，y坐标
tilemap._X,tilemap._Y=-80,-180
tilemap._rot=0
tilemap._sx=1
tilemap._sy=1
quadtable={}
player={}
player.X=400
player.Y=300
player.rot=0
player.sx=1
player.sy=1
speed=300

function love.load()
	image=love.graphics.newImage("assets/" .. tilemap["tilesets"][1].name ..tilemap["properties"]["format"])
	makeQuad(tilemap)
	player.img=love.graphics.newImage("assets/player.png")
	mainfont = love.graphics.newFont( 20 )
end

function love.draw()
	camera:set()
	drawMap(tilemap,image)
	love.graphics.draw(player.img,player.X,player.Y,
	player.rot,player.sx,player.sy,player.
	--设置图片的中心
	img:getWidth() / 2,player.img:getHeight() / 2)
	camera:unset()
	love.graphics.setFont(mainfont);
	love.graphics.print("player.X=" .. player.X .. "  player.Y=" .. player.Y,20,20)
end

function love.update(dt)
	--平移
	if(love.keyboard.isDown("up")) then
	player.Y=player.Y-speed*dt
	end
	if(love.keyboard.isDown("down")) then
	player.Y=player.Y+speed*dt
	end
	if(love.keyboard.isDown("left")) then
	player.X=player.X-speed*dt
	end
	if(love.keyboard.isDown("right")) then
	player.X=player.X+speed*dt
	end
	--旋转
	if(love.keyboard.isDown("j")) then
	player.rot=player.rot-0.5
	end
	if(love.keyboard.isDown("l")) then
	player.rot=player.rot+0.5
	end
	--缩放
	if (love.keyboard.isDown("i")) then
	player.sx=player.sx+0.1
	player.sy=player.sy+0.1
	end
	if (love.keyboard.isDown("k")) then
	player.sx=player.sx-0.1
	player.sy=player.sy-0.1
	end
	--设置摄相机的偏移
	camera:setOffset(player.X-400, player.Y-300)
end

function love.keypressed(key)

end

--鼠标事件
function love.mousepressed(x,y,button)
	if button=="wd" then
		player.sx=player.sx-0.1
		player.sy=player.sy-0.1
	end

	if button=="wu" then
		player.sx=player.sx+0.1
		player.sy=player.sy+0.1
	end
end
