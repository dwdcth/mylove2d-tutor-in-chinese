function love.load()
  love.graphics.setBackgroundColor(104, 136, 248) --设置背景为蓝色
  love.graphics.setMode(650, 650, false, true, 0) --设置窗口650*650,不全屏,开启垂直同步,全屏抗锯齿缓存0

  --下面是物理引擎的使用
  love.physics.setMeter(64) --设置64px(像素)为1米,box2d使用实际的物理体系单位
  world = love.physics.newWorld(0, 9.81*64, true) --创建一个世界,其水平加速度为0,竖直9.81m/s(即地球)

  objects = {} -- 物理对象table

  --创建地面
  objects.ground = {}
  objects.ground.body = love.physics.newBody(world, 650/2, 650-50/2)  --创建一个静态物体, 在世界world中的位置是(650/2, 650-50/2)
  objects.ground.shape = love.physics.newRectangleShape(650, 50)   --创建一个矩形
  objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)  --把矩形附加到物体

  --创建一个球
  objects.ball = {}
  objects.ball.body = love.physics.newBody(world, 650/2, 650/2, "dynamic") --创建一个动态物体
  objects.ball.shape = love.physics.newCircleShape(20) --创建一个圆形
  objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) --把圆形附加到物体上,密度为1
  objects.ball.fixture:setRestitution(0.7) --反弹系数,即碰撞反弹后速度为原来的0.7倍

  --创建一些方块
  objects.block1 = {}
  objects.block1.body = love.physics.newBody(world, 200, 550, "dynamic")
  objects.block1.shape = love.physics.newRectangleShape(0, 0, 50, 100)  --竖直的方块
  objects.block1.fixture = love.physics.newFixture(objects.block1.body, objects.block1.shape, 5) --密度比球大,质量更大

  objects.block2 = {}
  objects.block2.body = love.physics.newBody(world, 200, 650/2, "dynamic")
  objects.block2.shape = love.physics.newRectangleShape(0, 0, 100, 50)  --水平的方块
  objects.block2.fixture = love.physics.newFixture(objects.block2.body, objects.block2.shape, 2)


end


function love.update(dt)
  world:update(dt)


  if love.keyboard.isDown("right") then
    objects.ball.body:applyForce(400, 0) --给球(400,0)牛的力,力是矢量,即沿x轴正方向400,y轴正方向0
  elseif love.keyboard.isDown("left") then
    objects.ball.body:applyForce(-400, 0) --给球(-400,0)牛的力
  elseif love.keyboard.isDown("up") then
    objects.ball.body:applyForce(0,-400)
  end
end

function love.draw()
  love.graphics.setColor(72, 160, 14) -- 绿色,用来画地面
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))--使用地面坐标画多边形

  love.graphics.setColor(193, 47, 14) --红色,用来画球
  love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())

  love.graphics.setColor(50, 50, 50) --灰色,用来画方块
  love.graphics.polygon("fill", objects.block1.body:getWorldPoints(objects.block1.shape:getPoints()))
  love.graphics.polygon("fill", objects.block2.body:getWorldPoints(objects.block2.shape:getPoints()))
end
