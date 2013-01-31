local lg=love.graphics
function love.load()
	love.graphics.setMode(800, 640, false, true, 0) --设置窗口800*640,不全屏,开启垂直同步,全屏抗锯齿缓存0
	love.physics.setMeter(40) --设置40px(像素)为1米,汽车图片是120px长,这样就有3m了
	
	--创建一个水平加速度为3的世界,让接下来的汽车自己运动
	world = love.physics.newWorld(40*3, 0, true)
		--设置世界里的回调函数
        world:setCallbacks(beginContact, endContact, preSolve, postSolve)


  --创建汽车
  car = {}
  car.body = love.physics.newBody(world, 10, 640/2-90/2,"dynamic")  --创建汽车,把它放在x=100,图片中心放在屏幕竖直中心
  car.shape = love.physics.newRectangleShape(120, 90)   --创建一个矩形大小为汽车图片的大小
  car.fixture = love.physics.newFixture(car.body, car.shape)  --把矩形附加到汽车
  car.fixture:setUserData("car") --设置一些数据，可以通过getUserData取出以在其它地方使用

  --创建一个炸弹
  bomb = {}
  bomb.body = love.physics.newBody(world, 500, 640/2-90/2) --创建炸弹,把它放在x=500,图片中心放在屏幕竖直中心
  bomb.shape = love.physics.newRectangleShape(24,32) --创建一个矩形大小为炸弹图片的大小
  bomb.fixture = love.physics.newFixture(bomb.body, bomb.shape, 1) --把矩形附加到炸弹,密度为1
  bomb.fixture:setRestitution(0.3) --反弹系数,即碰撞反弹后速度为原来的0.3倍
  bomb.fixture:setUserData("bomb")
  


--加载图片	
imgCar=lg.newImage("assets/car.jpg")
imgBomb=lg.newImage("assets/bomb.jpg")
imgBlowing=lg.newImage("assets/blowing.png")
--爆炸音效
sound = love.audio.newSource("assets/blowing.mp3", "static") 

--用来输出碰撞的信息
text=""
collided=false
end

function love.update(dt)
    world:update(dt)
	
end

function love.draw()
  lg.print(text,10,10)
  if not collided then
   lg.draw(imgCar,car.body:getX(),car.body:getY())
   lg.draw(imgBomb,bomb.body:getX(),bomb.body:getY())
  else
   --创建爆炸,把图片中心放在炸弹的x坐标，y屏幕竖直中心
	lg.draw(imgBlowing,500-120/2,640/2-120/2)
  end
  --用来确定物理引擎的坐标系统是以左顶点还是中心，发现是坐顶点
   lg.print("bomb",500,640/2-90/2)
end

function beginContact(a, b, coll)
	collided=true
	love.audio.play(sound)
	text=text.."\n".."beginContact"
end

function endContact(a, b, coll)
text=text.."\n".."endContact"
end

function preSolve(a, b, coll)
text=text.."\n".."preSolve"
end
function postSolve(a, b, coll)
text=text.."\n".."postSolve"
end
 
